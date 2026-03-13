#!/bin/bash
set -euo pipefail

NAMESPACE=xdev
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
load_env

helm upgrade --install redis redis \
  --create-namespace \
  --set architecture=standalone \
  --set auth.enabled=false \
  --set master.service.type=ClusterIP \
  --set persistence.size=1Gi \
  --set persistence.storageClass=local-path \
  --namespace "$NAMESPACE"
