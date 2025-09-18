#!/bin/sh
set -e

echo "[entrypoint] Generating config.yaml from template + ENV..."

sed "s|\${ETCD_HOST}|${ETCD_HOST}|g;
     s|\${ETCD_USER}|${ETCD_USER}|g;
     s|\${ETCD_PASSWORD}|${ETCD_PASSWORD}|g;
     s|\${APISIX_ADMIN_API_KEY}|${APISIX_ADMIN_API_KEY}|g;
     s|\${APISIX_NODE_LISTEN}|${APISIX_NODE_LISTEN}|g;
     s|\${APISIX_SSL_LISTEN}|${APISIX_SSL_LISTEN}|g" \
     /usr/local/apisix/conf/config-template.yaml > /usr/local/apisix/conf/config.yaml

echo "[entrypoint] ✅ config.yaml created"
exec apisix start -c /usr/local/apisix/conf/config.yaml

