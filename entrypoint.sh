#!/bin/sh
set -e

echo "[entrypoint] Generating config.yaml from template + ENV..."

# Tạo config.yaml từ template, thay các biến
envsubst '\
${ETCD_HOST} \
${ETCD_USER} \
${ETCD_PASSWORD} \
${APISIX_ADMIN_API_KEY} \
${APISIX_NODE_LISTEN} \
${APISIX_SSL_LISTEN} \
' < /usr/local/apisix/conf/config-template.yaml > /usr/local/apisix/conf/config.yaml

echo "[entrypoint] Starting APISIX CP"
exec apisix start -c /usr/local/apisix/conf/config.yaml

