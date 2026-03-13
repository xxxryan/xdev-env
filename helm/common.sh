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
