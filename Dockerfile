FROM eclipse-temurin:17.0.7_7-jre-focal

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
    apt-get install -y tzdata netcat ca-certificates && \
    mkdir /tachidesk && \
    groupadd -r tachidesk -g 911 && \
    useradd -r tachidesk -g tachidesk -d /tachidesk -s /bin/bash -u 911 && \
    curl -L $(curl -s https://api.github.com/repos/suwayomi/tachidesk-server/releases/latest | grep -o "https.*jar") -o /tachidesk/tachidesk_latest.jar && \
    chown -R tachidesk:tachidesk /tachidesk && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf \
        /tmp/* \
        /root/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/*

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]

EXPOSE 4567