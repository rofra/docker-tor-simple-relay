#
# Dockerfile for tor
#
FROM debian:stretch-slim
LABEL maintainer="Rodolphe Franceschi <rodolphe.franceschi@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

ENV VERSION "0.4.1.6"
ENV BASENAME "tor-${VERSION}"
ENV ARCHIVE_NAME "${BASENAME}.tar.gz"
ENV SIGNATURE_NAME "${ARCHIVE_NAME}.asc"
ENV PACKAGE_URL "https://dist.torproject.org/${ARCHIVE_NAME}"
ENV SIGNATURE_URL "https://dist.torproject.org/${SIGNATURE_NAME}"

ENV PGP_SERVER "pgp.mit.edu"
ENV PGP_KEY "0x6AFEE6D49E92B601"

ENV DEPENDENCY_LIST "wget gpg build-essential automake libevent-dev libssl-dev zlib1g-dev liblzma-dev libzstd-dev python3 zstd pkg-config"

# Install dependencies
RUN apt-get update \
    && apt-get install -y apt-utils 2>&1 \
    && apt-get install -y ${DEPENDENCY_LIST} \
    && rm -rf /var/lib/apt/lists/*

# Import tor GPG keys
RUN gpg --keyserver ${PGP_SERVER} --recv-keys ${PGP_KEY}
RUN gpg --fingerprint ${PGP_KEY}

# Download and verify signature
RUN set -ex \
    && cd /tmp \
    && wget -qO "${ARCHIVE_NAME}" "${PACKAGE_URL}" \
    && wget -qO "${SIGNATURE_NAME}" "${SIGNATURE_URL}" \
    && gpg --verify "${SIGNATURE_NAME}" "${ARCHIVE_NAME}"

# Compile
RUN set -ex \
    && cd /tmp/ \
    && tar -zxvf ${ARCHIVE_NAME} \
    && cd ${BASENAME} \
    # && ./autogen.sh \
    && ./configure --disable-asciidoc \
    && make \
    && make install

# Cleanup
RUN rm -fr /tmp/tor \
    && rm -fr /root/.gnupg \
    && apt-get remove -y --purge ${DEPENDENCY_LIST}

# Install custom tor proxies
RUN set -ex \
    && apt-get update \
    && apt-get install -y fteproxy obfsproxy obfs4proxy \
    && rm -rf /var/lib/apt/lists/*

# Configure the user and the WORKDIR
RUN useradd -d /home/tor -s /bin/false tor
RUN mkdir /home/tor
RUN chown -R tor.tor /home/tor
RUN chmod -R 755 /home/tor

# Cleanup env variables
RUN unset DEBIAN_FRONTEND BASENAME VERSION ARCHIVE_NAME SIGNATURE_NAME PACKAGE_URL SIGNATURE_URL PGP_SERVER PGP_KEY DEPENDENCY_LIST

# IP Exposed
EXPOSE 9001 9030 9050 9051 46396

# User / group / right management
RUN mkdir /var/lib/tor
RUN chmod -R 744 /var/lib/tor
RUN chown tor.tor /var/lib/tor /var/lib
WORKDIR /var/lib/tor
VOLUME /etc/tor /var/lib/tor

# Add Base configuration
COPY ./torrc.base /torrc.base

# Entrypoint
COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER tor
