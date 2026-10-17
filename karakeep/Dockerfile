FROM litestream/litestream:0.5.17@sha256:4b02b9859a6b6b4087d8b8944e15f7e984bd7957cba322bbeee38b0e27b9656a AS litestream

FROM ghcr.io/karakeep-app/karakeep:0.33.2@sha256:3d57623bf031f32a0597a3ebe0cd869bff6ba181c02ebc90fac492458bcfd4a4

COPY --from=litestream /usr/local/bin/litestream /usr/local/bin/litestream
COPY litestream.yml /etc/litestream.yml
COPY karakeep-start karakeep-serve /usr/local/bin/
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/karakeep-start"]
