#!/bin/bash
set -euo pipefail

NAMESPACE=xdev
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
load_env
ensure_helm_repo

helm upgrade --install redis bitnami/redis \
  --create-namespace \
  --set architecture=standalone \
  --set auth.enabled=false \
  --set master.service.type=ClusterIP \
  --set persistence.size=1Gi \
  --set persistence.storageClass=local-path \
  --namespace "$NAMESPACE"

ensure_local_port_forward "$NAMESPACE" "redis-master" "$REDIS_PORT" "6379" "redis"
echo "Redis is available at localhost:${REDIS_PORT}"
