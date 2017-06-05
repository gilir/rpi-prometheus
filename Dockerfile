FROM arm32v6/alpine:3.6

# Upgrating the image first, to have the last version of all packages, and to
# share the same layer accros the images
RUN apk --no-cache upgrade \
    && apk --no-cache add \
       su-exec \
       ca-certificates

ARG PROMETHEUS_VERSION=1.6.3

ADD https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-armv7.tar.gz /tmp/

RUN cd /tmp && \
    tar -xvf prometheus-$PROMETHEUS_VERSION.linux-armv7.tar.gz && \
    cd prometheus-* && \
    mkdir -p /etc/prometheus && \
    mv prometheus /bin/prometheus && \
    mv promtool /bin/promtool && \
    mv prometheus.yml /etc/prometheus/prometheus.yml && \
    mv console_libraries /etc/prometheus/ && \
    mv consoles /etc/prometheus/ && \
    cd /tmp && rm -rf prometheus-$PROMETHEUS_VERSION.linux-armv7

EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "-config.file=/etc/prometheus/prometheus.yml", \
             "-storage.local.path=/prometheus", \
             "-web.console.libraries=/etc/prometheus/console_libraries", \
             "-web.console.templates=/etc/prometheus/consoles" ]
