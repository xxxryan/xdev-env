#!/bin/bash
set -euo pipefail

NAMESPACE=xdev
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
load_env

KONG_PORT="${KONG_PORT:-8000}"

helm repo add kong https://charts.konghq.com
helm repo update

helm upgrade --install kong kong/kong \
  --create-namespace \
  -f "$SCRIPT_DIR/kong/values.yaml" \
  --namespace "$NAMESPACE"

echo ""
echo "Test with:"
echo "  curl -s -X POST http://localhost:${KONG_PORT}/eth/mainnet \\"
echo "    -H 'Content-Type: application/json' \\"
echo "    -H 'apikey: dev-api-key-changeme' \\"
echo "    -d '{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}'"
