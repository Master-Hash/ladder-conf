FROM golang:alpine

RUN apk add --no-cache --virtual .build-deps git \
    && git clone https://github.com/v2fly/v2ray-core.git \
    && cd v2ray-core \
    # Compile Guild
    # https://www.v2fly.org/developer/intro/compile.html
    && CGO_ENABLED=0 go build -o ./v2ray -trimpath -ldflags "-s -w -buildid=" ./main

FROM alpine:latest

COPY --from=0 /go/v2ray-core/v2ray /usr/local/bin/v2ray
COPY ./config.json /etc/v2ray/config.json
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache tzdata openssl ca-certificates \
    && mkdir /usr/local/share/v2ray \
    && wget -qO /usr/local/share/v2ray/geoip.dat https://github.com/v2fly/geoip/raw/release/geoip.dat \
    && wget -qO /usr/local/share/v2ray/geosite.dat https://github.com/v2fly/domain-list-community/raw/release/dlc.dat

# ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
EXPOSE 8081
CMD ["v2ray", "run", "-c", "/etc/v2ray/config.json", "-format", "jsonv5"]
