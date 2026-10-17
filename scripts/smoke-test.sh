#!/usr/bin/env bash
# Starts every image restricted (its own user, a read-only root, every capability dropped)
# beside Garage, signs a user up, then replaces the karakeep container with a fresh one and
# checks that it restored the user from Garage rather than starting empty.
# Usage: scripts/smoke-test.sh <karakeep-image> <chrome-image> <search-image>
set -euo pipefail
karakeep_image=$1
chrome_image=$2
search_image=$3
net=karakeep-smoke
here=$(cd "$(dirname "$0")" && pwd)
containers=(smoke-garage smoke-search smoke-chrome smoke-karakeep)
key_hex=0123456789abcdef0123456789abcdef
key_secret=$(printf 's%.0s' $(seq 1 64))

cleanup() {
  docker rm -f "${containers[@]}" >/dev/null 2>&1 || true
  docker network rm "$net" >/dev/null 2>&1 || true
}
trap cleanup EXIT
cleanup
docker network create "$net" >/dev/null

docker run -d --name smoke-garage --network "$net" -v "$here/garage.toml:/etc/garage.toml:ro" \
  dxflrs/garage:v2.3.0 >/dev/null
garage() { docker exec smoke-garage /garage "$@" 2>/dev/null; }
until garage status >/dev/null 2>&1; do sleep 1; done
node=$(garage status 2>/dev/null | awk '/^[0-9a-f]{16}/ {print $1; exit}')
garage layout assign -z smoke -c 1G "$node" >/dev/null
garage layout apply --version 1 >/dev/null
garage key import --yes -n karakeep "GK${key_hex:0:24}" "$key_secret" >/dev/null
for bucket in karakeep-assets karakeep-litestream; do
  garage bucket create "$bucket" >/dev/null
  garage bucket allow --read --write --owner "$bucket" --key karakeep >/dev/null
done

restricted=(--network "$net" --read-only --cap-drop ALL --security-opt no-new-privileges)

docker run -d --name smoke-search "${restricted[@]}" --user 1000:1000 \
  --tmpfs '/meili_data:uid=1000,gid=1000' --tmpfs '/tmp:uid=1000,gid=1000,mode=1777' \
  -e MEILI_MASTER_KEY=smoke-master-key-0123456789 -e MEILI_NO_ANALYTICS=true "$search_image" >/dev/null
docker run -d --name smoke-chrome "${restricted[@]}" --user 65534:65534 \
  --tmpfs '/tmp:uid=65534,gid=65534,mode=1777' "$chrome_image" >/dev/null

start_karakeep() {
  docker run -d --name smoke-karakeep "${restricted[@]}" --user 1000:1000 \
    --tmpfs '/data:uid=1000,gid=1000' --tmpfs '/tmp:uid=1000,gid=1000,mode=1777' \
    -e DATA_DIR=/data -e HOSTNAME=0.0.0.0 -e NEXTAUTH_SECRET=smoke -e NEXTAUTH_URL=http://localhost:3000 \
    -e KARAKEEP_SEARCH_HOST=smoke-search -e KARAKEEP_SEARCH_PORT=7700 -e MEILI_MASTER_KEY=smoke-master-key-0123456789 \
    -e KARAKEEP_CHROME_HOST=smoke-chrome -e KARAKEEP_CHROME_PORT=9222 \
    -e KARAKEEP_S3_ENDPOINT=http://smoke-garage:3900 -e KARAKEEP_S3_REGION=garage \
    -e KARAKEEP_S3_KEY_HEX="$key_hex" -e KARAKEEP_S3_SECRET_ACCESS_KEY="$key_secret" \
    -e KARAKEEP_LITESTREAM_BUCKET=karakeep-litestream -e ASSET_STORE_S3_BUCKET=karakeep-assets \
    "$karakeep_image" >/dev/null
  for _ in $(seq 1 60); do
    if docker exec smoke-karakeep node -e "fetch('http://127.0.0.1:3000/api/health').then(r => process.exit(r.ok ? 0 : 1), () => process.exit(1))" 2>/dev/null; then
      echo "karakeep serves /api/health"
      return 0
    fi
    if [ "$(docker inspect -f '{{.State.Running}}' smoke-karakeep)" != true ]; then
      docker logs smoke-karakeep 2>&1 | tail -40
      echo "karakeep exited before it served" >&2
      return 1
    fi
    sleep 5
  done
  docker logs smoke-karakeep 2>&1 | tail -40
  echo "karakeep never served /api/health" >&2
  return 1
}

# signup prints the tRPC response to creating smoke@example.com.
signup() {
  docker exec smoke-karakeep node -e "
    fetch('http://127.0.0.1:3000/api/trpc/users.create', {method: 'POST', headers: {'content-type': 'application/json'},
      body: JSON.stringify({json: {name: 'smoke', email: 'smoke@example.com', password: 'smoke-password-1', confirmPassword: 'smoke-password-1'}})})
      .then(r => r.text()).then(t => console.log(t))"
}

start_karakeep
first=$(signup)
echo "$first" | head -c 300; echo
echo "$first" | grep -q '"email":"smoke@example.com"' || { echo "signup did not create the user" >&2; exit 1; }

# Litestream syncs every second; give it a few before the container goes.
sleep 5
docker rm -f smoke-karakeep >/dev/null
start_karakeep
docker logs smoke-karakeep 2>&1 | grep -iE "restor|litestream" | head -8 || true
second=$(signup)
echo "$second" | head -c 300; echo
echo "$second" | grep -qiE 'already|exists|taken|CONFLICT' || { echo "a fresh karakeep did not restore the user from Garage" >&2; exit 1; }

# The crawler reaches chrome over its own address, not localhost, which resolved to ::1. karakeep
# logs a failed connection and nothing on success, so wait out a few retries and look for none.
until docker logs smoke-karakeep 2>&1 | grep -q 'Successfully resolved IP address'; do sleep 2; done
sleep 15
if docker logs smoke-karakeep 2>&1 | grep -q 'Failed to connect to the browser'; then
  docker logs smoke-karakeep 2>&1 | grep -m3 'browser' >&2
  echo "the crawler cannot reach chrome" >&2
  exit 1
fi
echo "the crawler connected to chrome"

for c in smoke-search smoke-chrome smoke-karakeep; do
  others=$(docker top "$c" -eo pid,uid,comm | tail -n +2 | awk '$2 != 1000 && $2 != 65534')
  [ -z "$others" ] || { echo "$c runs a process as another uid: $others" >&2; exit 1; }
done
echo "smoke test passed"
