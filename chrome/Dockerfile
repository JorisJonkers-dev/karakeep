FROM ghcr.io/karakeep-app/karakeep-chrome:release@sha256:5b19bbb160e9ff60681a3abd97e1c4ec9f64212301410de658c3900ab7ef31e7

COPY chrome-start /usr/local/bin/chrome-start
ENV HOME=/tmp
USER 65534:65534
ENTRYPOINT ["/usr/local/bin/chrome-start"]
