#!/bin/sh
set -e

echo "[entrypoint] Generating config.yaml from template + ENV..."

# --- Build node_listen block (support multi-port "9080,9081")
NODE_LISTEN_VAL=$(echo "${APISIX_NODE_LISTEN:-9080}" | awk -F',' '{for(i=1;i<=NF;i++) print "  - "$i}')

# --- Boolean for SSL
SSL_ENABLE_VAL=$([ "${APISIX_SSL_ENABLE}" = "true" ] && echo true || echo false)

# --- Replace placeholders safely
sed "s|__APISIX_NODE_LISTEN__|$NODE_LISTEN_VAL|g;
     s|__APISIX_SSL_ENABLE__|$SSL_ENABLE_VAL|g;
     s|__APISIX_SSL_LISTEN__|${APISIX_SSL_LISTEN:-9443}|g;
     s|__APISIX_ADMIN_API_KEY__|${APISIX_ADMIN_API_KEY:-edd1c9f034335f136f87ad84b625c8f1}|g;
     s|__ETCD_HOST__|${ETCD_HOST:-http://etcd-service:2379}|g;
     s|__ETCD_USER__|${ETCD_USER:-root}|g;
     s|__ETCD_PASSWORD__|${ETCD_PASSWORD:-L0caladm;;;}|g" \
     /usr/local/apisix/conf/config-template.yaml > /usr/local/apisix/conf/config.yaml

echo "[entrypoint] ✅ config.yaml created"
echo "-----------------------------------"
cat /usr/local/apisix/conf/config.yaml
echo "-----------------------------------"

# Start APISIX
exec apisix start -c /usr/local/apisix/conf/config.yaml

