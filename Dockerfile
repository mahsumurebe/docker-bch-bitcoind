# Smallest base image, latests stable image
# Alpine would be nice, but it's linked again musl and breaks the bitcoin core download binary
#FROM alpine:latest

FROM ubuntu:latest as builder

# Testing: gosu
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
#    && apk add --update --no-cache gnupg gosu gcompat libgcc
RUN apt update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=23.0.0
ARG ARCH=x86_64


# Don't use base image's bitcoin package for a few reasons:
# 1. Would need to use ppa/latest repo for the latest release.
# 2. Some package generates /etc/bitcoin.conf on install and that's dangerous to bake in with Docker Hub.
# 3. Verifying pkg signature from main website should inspire confidence and reduce chance of surprises.
# Instead fetch, verify, and extract to Docker image
RUN cd /tmp \
    wget https://download.bitcoincashnode.org/releases/${VERSION}/SHA256SUMS.${VERSION}.freetrader.txt.asc \
    grep bitcoin-cash-node-${VERSION}-${ARCH}-linux-gnu.tar.gz SHA256SUMS.${VERSION}.freetrader.txt.asc > SHA25SUM \
    wget https://download.bitcoincashnode.org/releases/${VERSION}/linux/bitcoin-cash-node-${VERSION}-${ARCH}-linux-gnu.tar.gz \
    sha256sum -c SHA25SUM \
    tar -xzvf bitcoin-cash-node-${VERSION}-${ARCH}-linux-gnu.tar.gz -C /opt \
    ln -sv bitcoin-cash-node-${VERSION} /opt/bitcoin \
    rm -v /opt/bitcoin/bin/bitcoin-qt

FROM ubuntu:latest
LABEL maintainer="Mahsum Urebe <info@mahsumurebe.com>"

ENTRYPOINT ["docker-entrypoint.sh"]
ENV HOME /bitcoin
EXPOSE 8332 8333
VOLUME ["/bitcoin/.bitcoin"]
WORKDIR /bitcoin

ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} bitcoin \
    && useradd -u ${USER_ID} -g bitcoin -d /bitcoin bitcoin

COPY --from=builder /opt/ /opt/

RUN apt update \
    && apt install -y --no-install-recommends gosu \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sv /opt/bitcoin/bin/* /usr/local/bin

COPY ./bin ./docker-entrypoint.sh /usr/local/bin/

CMD ["btc_oneshot"]
