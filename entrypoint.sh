#!/bin/sh
set -e

echo "[entrypoint] 🚀 Generating config.yaml from ENV..."

cat <<EOF > /usr/local/apisix/conf/config.yaml
apisix:
  node_listen: ${APISIX_NODE_LISTEN:-9080}
  enable_admin: ${APISIX_ENABLE_ADMIN:-true}
  enable_debug: ${APISIX_ENABLE_DEBUG:-false}
  config_center: ${APISIX_CONFIG_CENTER:-etcd}
  allow_admin:
    - 0.0.0.0/0
  admin_key:
    - name: admin
      key: ${APISIX_ADMIN_API_KEY:-edd1c9f034335f136f87ad84b625c8f1}
      role: admin

etcd:
  host:
    - ${ETCD_HOST:-http://127.0.0.1:2379}
  prefix: ${ETCD_PREFIX:-/apisix}
  timeout: ${ETCD_TIMEOUT:-30}
  user:
    - ${ETCD_USER:-root}
  password:
    - ${ETCD_PASSWORD:-L0caladm;;;}

deployment:
  role: control_plane
  role_control_plane:
    config_provider: etcd

plugins:
  - cors
  - jwt-auth
  - key-auth
  - rate-limit
  - ip-restriction
  - proxy-cache
  - prometheus
  - request-validation
  - openid-connect
  - grpc-transcode
EOF

echo "[entrypoint] ✅ config.yaml created"

exec apisix start

