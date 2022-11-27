#!/bin/sh

set -e

export UUID=${UUID:-$(v2ray uuid)}
export NETWORK=${NETWORK:-ws}
echo "UUID: ${UUID}"
echo "NETWORK: ${NETWORK}"

if [ -f /etc/v2ray/config.json ]; then
    echo "config.json already exists."
else
    cp /etc/v2ray/config.json.template /etc/v2ray/config.json
    sed -i "s/%%UUID%%/${UUID}/g" /etc/v2ray/config.json
    sed -i "s/%%NETWORK%%/${NETWORK}/g" /etc/v2ray/config.json
fi

if [[ ${NETWORK} == "grpc" ]]; then
    sed -i "s/%%EXTRA_SETUP%%/,\"grpcSettings\": {\"serviceName\": \"v2ray\"}/g" /etc/v2ray/config.json
else
    sed -i "s/%%EXTRA_SETUP%%//g" /etc/v2ray/config.json
fi

exec "$@"
