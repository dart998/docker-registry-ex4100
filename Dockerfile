FROM debian:bullseye-slim

ARG REGISTRY_VERSION=3.1.1
ARG TARGETARCH
ARG TARGETVARIANT

RUN set -eux; \
    printf '%s\n' \
      'deb http://archive.debian.org/debian bullseye main' \
      'deb http://archive.debian.org/debian bullseye-updates main' \
      'deb http://archive.debian.org/debian-security bullseye-security main' \
      > /etc/apt/sources.list; \
    printf '%s\n' 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl tar; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    case "${TARGETARCH}/${TARGETVARIANT}" in \
      arm/v7) ARCH="armv7" ;; \
      arm/v6) ARCH="armv6" ;; \
      arm64/*|arm64/) ARCH="arm64" ;; \
      amd64/*|amd64/) ARCH="amd64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}/${TARGETVARIANT}" >&2; exit 1 ;; \
    esac; \
    curl -fL "https://github.com/distribution/distribution/releases/download/v${REGISTRY_VERSION}/registry_${REGISTRY_VERSION}_linux_${ARCH}.tar.gz" \
      -o /tmp/registry.tar.gz; \
    tar -xzf /tmp/registry.tar.gz -C /tmp; \
    install -m 0755 /tmp/registry /usr/local/bin/registry; \
    rm -rf /tmp/registry /tmp/registry.tar.gz

COPY config.yml /etc/distribution/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

ENTRYPOINT ["/usr/local/bin/registry"]
CMD ["serve", "/etc/distribution/config.yml"]
