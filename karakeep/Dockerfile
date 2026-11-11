FROM litestream/litestream:0.5.18@sha256:513bff62a88fc0c86c73d27333c41c54c89fe890a7c32a551600adff9309b11b AS litestream

FROM ghcr.io/karakeep-app/karakeep:0.33.2@sha256:3d57623bf031f32a0597a3ebe0cd869bff6ba181c02ebc90fac492458bcfd4a4

COPY --from=litestream /usr/local/bin/litestream /usr/local/bin/litestream
COPY litestream.yml /etc/litestream.yml
COPY karakeep-start karakeep-serve /usr/local/bin/
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/karakeep-start"]
