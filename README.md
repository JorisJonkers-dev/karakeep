# karakeep

[Karakeep](https://github.com/karakeep-app/karakeep) at `karakeep.jorisjonkers.dev`,
as the estate runs it: upstream's karakeep, chrome and meilisearch images,
changed only so that they run under the estate's restricted posture, with
karakeep's state in Garage. deploy-kit delivers them as the Project `karakeep`.

## What the images change

Each image runs as a numeric non-root user with a read-only root filesystem
and every capability dropped.

- **`karakeep/`**
  - Upstream starts the database migration, the web server and the workers
    under s6 as root. Here they run as uid 1000: `karakeep-start` migrates,
    then `karakeep-serve` runs the web server and the workers side by side.
    If either exits, the other stops too.
  - Assets go to Garage through karakeep's S3 asset store.
  - Both SQLite databases, `db.db` and `queue.db`, are restored from Garage
    before karakeep opens them. [Litestream](https://litestream.io) then
    streams every write back, about a second behind.
  - So `/data` is scratch, and a new pod on any node starts where the last
    one stopped.
  - The entrypoint also builds the search and browser URLs, and the S3 key
    id, from the separate values the estate delivers.
- **`chrome/`** is upstream's headless chrome, started with the flags the old
  deployment passed as arguments.
- **`search/`** is meilisearch as uid 1000. Its index is the only volume, and
  karakeep can rebuild it.

## Running it

`deploy/karakeep.project.yml` and `deploy/env/` declare the Project. Each
release builds the images and publishes the Intent Fragment that the estate
composes.

`scripts/smoke-test.sh` starts every image restricted beside Garage and signs
a user up. It then replaces karakeep with a fresh container and checks that
the user was restored from Garage. It also checks that the crawler reached
chrome. CI runs it on every change.

## Licence

Karakeep is licensed under the GNU Affero General Public License v3, and so is
this repository: see [LICENSE](LICENSE).
