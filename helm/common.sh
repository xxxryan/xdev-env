#!/bin/bash
# Shared helpers for helm install scripts. Source from helm/*.sh with:
#   SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
#   REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Ensure REPO_ROOT is set by caller (script that sources this file).
# Typically: SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd); REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Load .env from repo root if present. No-op if file missing (CI may use env only).
load_env() {
  local env_file="${REPO_ROOT:?REPO_ROOT not set}/.env"
  if [[ -f "$env_file" ]]; then
    set -a
    # shellcheck source=/dev/null
    source "$env_file"
    set +a
  fi
}

# Add bitnami repo and update index.
ensure_helm_repo() {
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
}

# Start kubectl port-forward to localhost and persist in background.
# Args: namespace service_name local_port remote_port log_name
ensure_local_port_forward() {
  local namespace="$1"
  local service_name="$2"
  local local_port="$3"
  local remote_port="$4"
  local log_name="$5"
  local log_dir="${REPO_ROOT:?REPO_ROOT not set}/.tmp/port-forward"
  local log_file="${log_dir}/${log_name}.log"

  if ! command -v kubectl >/dev/null 2>&1; then
    echo "Error: kubectl is required for localhost port-forward." >&2
    exit 1
  fi

  if lsof -nP -iTCP:"${local_port}" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "localhost:${local_port} is already listening, skip starting a new port-forward."
    return 0
  fi

  mkdir -p "${log_dir}"
  nohup kubectl -n "${namespace}" port-forward "svc/${service_name}" "${local_port}:${remote_port}" \
    >"${log_file}" 2>&1 &

  # Give port-forward a moment to bind the local port.
  sleep 1
  if ! lsof -nP -iTCP:"${local_port}" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "Error: failed to start port-forward for svc/${service_name}. Check ${log_file}." >&2
    exit 1
  fi
}
