#!/bin/bash
set -euo pipefail

NAMESPACE=xdev
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
load_env

POSTGRES_PORT="${POSTGRES_PORT:-5432}"

if [[ -z "${POSTGRES_PASSWORD:-}" ]] || [[ -z "${POSTGRES_DB:-}" ]] || [[ -z "${POSTGRES_USER:-}" ]] || [[ -z "${POSTGRES_PORT:-}" ]]; then
  echo "Error: POSTGRES_PORT, POSTGRES_PASSWORD, POSTGRES_DB, and POSTGRES_USER must be set (e.g. in .env)." >&2
  exit 1
fi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install postgres bitnami/postgresql \
  --create-namespace \
  --set auth.postgresPassword="root" \
  --set auth.username="${POSTGRES_USER}" \
  --set auth.password="${POSTGRES_PASSWORD}" \
  --set auth.database="${POSTGRES_DB}" \
  --set primary.service.type=NodePort \
  --set primary.service.nodePorts.postgresql="${POSTGRES_PORT}" \
  --set persistence.size=1Gi \
  --set persistence.storageClass=local-path \
  --namespace "$NAMESPACE"

echo ""
echo "PostgreSQL is available at 127.0.0.1:${POSTGRES_PORT}"
echo "  psql \"postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:${POSTGRES_PORT}/${POSTGRES_DB}\""
