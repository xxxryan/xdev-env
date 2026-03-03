#!/bin/bash
set -euo pipefail

NAMESPACE=xdev
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
load_env
ensure_helm_repo

# Required for bitnami/postgresql
if [[ -z "${POSTGRES_PASSWORD:-}" ]] || [[ -z "${POSTGRES_DB:-}" ]] || [[ -z "${POSTGRES_USER:-}" ]]; then
  echo "Error: POSTGRES_PASSWORD, POSTGRES_DB, and POSTGRES_USER must be set (e.g. in .env)." >&2
  exit 1
fi

helm upgrade --install postgres bitnami/postgresql \
  --create-namespace \
  --set auth.postgresPassword="${POSTGRES_PASSWORD}" \
  --set auth.database="${POSTGRES_DB}" \
  --set auth.username="${POSTGRES_USER}" \
  --set persistence.size=5Gi \
  --set persistence.storageClass=local-path \
  --set primary.service.type=ClusterIP \
  --namespace "$NAMESPACE"

ensure_local_port_forward "$NAMESPACE" "postgres-postgresql" "$POSTGRES_PORT" "5432" "postgres"
echo "PostgreSQL is available at localhost:${POSTGRES_PORT}"
