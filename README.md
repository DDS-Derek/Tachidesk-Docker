# Tachidesk-Docker

A better tachidesk docker container

Tachidesk server project: https://github.com/Suwayomi/Tachidesk-Server

Dockerhub: https://hub.docker.com/r/ddsderek/tachidesk

## Function

- PUID and PGID settings.
- Umask setting.
- Custom startup parameters.
- The config and download paths are separated by default, making management more convenient.
- Support to customize the download path in the container through environment variables

## Get start

**docker-cli**

```bash
docker run -d \
    --name=tachidesk \
    -p 4567:4567 \
    -v /path/to/config:/config \
    -v /path/to/downloads:/downloads \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=022 \
    -e TZ="Asia/Shanghai" \
    -e JAVA_OPTS= `#optional` \
    -e DOWNLOAD_DIR= `#optional` \
    --log-driver "json-file" \
    --log-opt "max-size=10m" \
    ddsderek/tachidesk:latest
```

**docker-compose**

```yaml
version: '3.3'
services:
    tachidesk:
        container_name: tachidesk
        ports:
            - '4567:4567'
        volumes:
            - '/path/to/config:/config'
            - '/path/to/downloads:/downloads'
        environment:
            - PUID=1000
            - PGID=1000
            - UMASK=022
            - TZ=Asia/Shanghai
            - JAVA_OPTS= #optional
            - DOWNLOAD_DIR= #optional
        logging:
            driver: "json-file"
            options:
                max-size: "10m"
        image: 'ddsderek/tachidesk:latest'
```