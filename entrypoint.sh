#!/bin/sh
set -e

echo "[entrypoint] Generating config.yaml from template..."

SSL_ENABLE_VAL=$([ "$APISIX_SSL_ENABLE" = "true" ] && echo true || echo false)

sed "s|__ETCD_HOST__|${ETCD_HOST:-http://etcd-service:2379}|g;
     s|__ETCD_USER__|${ETCD_USER:-root}|g;
     s|__ETCD_PASSWORD__|${ETCD_PASSWORD:-L0caladm;;; }|g;
     s|__APISIX_ADMIN_API_KEY__|${APISIX_ADMIN_API_KEY:-your-super-secret-key}|g;
     s|__APISIX_SSL_ENABLE__|${SSL_ENABLE_VAL}|g;
     s|__APISIX_SSL_LISTEN__|${APISIX_SSL_LISTEN:-9443}|g;" \
     /usr/local/apisix/conf/config-template.yaml > /usr/local/apisix/conf/config.yaml

# xử lý node_listen thành YAML list
NODE_LISTEN_VAL=$(echo "${APISIX_NODE_LISTEN:-9080}" | awk -F',' '{for(i=1;i<=NF;i++) print "  - "$i}')
sed -i "s|__APISIX_NODE_LISTEN__|PLACEHOLDER|g" /usr/local/apisix/conf/config.yaml
sed -i "/PLACEHOLDER/r /dev/stdin" /usr/local/apisix/conf/config.yaml <<EOF
$NODE_LISTEN_VAL
EOF
sed -i "s|PLACEHOLDER||g" /usr/local/apisix/conf/config.yaml

echo "[entrypoint] ✅ config.yaml created"
exec apisix start -c /usr/local/apisix/conf/config.yaml

