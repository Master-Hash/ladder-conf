#!/bin/sh

set -e

export UUID=${UUID:-$(v2ray uuid)}
echo "UUID: ${UUID}"

cp /etc/v2ray/config.json.template /etc/v2ray/config.json
sed -i "s/%%UUID%%/${UUID}/g" /etc/v2ray/config.json

exec "$@"
