ARG BUILD_TAG

FROM ghcr.io/suwayomi/tachidesk:${BUILD_TAG} AS Build

FROM eclipse-temurin:11.0.21_9-jre-jammy

ENV S6_SERVICES_GRACETIME=30000 \
    S6_KILL_GRACETIME=60000 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SYNC_DISKS=1 \
    TERM="xterm" \
    PATH=${PATH}:/command \
    TZ="Asia/Shanghai" \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

COPY --from=shinsenter/s6-overlay:v3.1.5.0 / /

RUN set -xe && \
    ln -sf /command/with-contenv /usr/bin/with-contenv && \
    export DEBIAN_FRONTEND="noninteractive" && \
    apt-get update -y && \
    apt-get install -y netcat && \
    mkdir /tachidesk && \
    groupadd -r tachidesk -g 911 && \
    useradd -r tachidesk -g tachidesk -d /tachidesk -s /bin/bash -u 911 && \
    chown tachidesk:tachidesk /tachidesk && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

COPY --from=Build --chmod=755 /home/suwayomi/startup/tachidesk_latest.jar /tachidesk/tachidesk_latest.jar

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]

EXPOSE 4567