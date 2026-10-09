#!/usr/bin/env bash
# Resolve BUNDLE_ROOT and load paths.env.  Sourced by every entrypoint.
# Contract: the repo is organised as
#   00_envs 01_code 02_checkpoints 03_data 04_entrypoints 05_results 06_external_links work
set -euo pipefail
_HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export BUNDLE_ROOT=$(cd "$_HERE/.." && pwd)
if [[ -f "$BUNDLE_ROOT/paths.env" ]]; then
  # shellcheck disable=SC1091
  source "$BUNDLE_ROOT/paths.env"
elif [[ -f "$BUNDLE_ROOT/paths.env.example" ]]; then
  # shellcheck disable=SC1091
  source "$BUNDLE_ROOT/paths.env.example"
fi

mkdir -p "$EXP_ROOT"/{outputs,logs,reports,tmp,lora_checkpoint,data_index}

# ---- Wire adapter/dataset into EXP_ROOT layout expected by scripts ----
# Symlink names are DERIVED from the basename of each configured path, so the
# template works for any repo without editing hardcoded names.  Guarded so it
# is usable before real assets are linked.
if [[ -n "${ADAPTER_DIR:-}" ]]; then
  ln -sfn "$ADAPTER_DIR" "$EXP_ROOT/lora_checkpoint/$(basename "$ADAPTER_DIR")"
fi
if [[ -n "${DATASET:-}" ]]; then
  ln -sfn "$DATASET" "$EXP_ROOT/data_index/$(basename "$DATASET")"
fi
if [[ -n "${TRAFFIC_JSONL:-}" ]]; then
  ln -sfn "$TRAFFIC_JSONL" "$EXP_ROOT/data_index/$(basename "$TRAFFIC_JSONL")"
fi
if [[ -n "${CONFLICT_JSONL:-}" ]]; then
  ln -sfn "$CONFLICT_JSONL" "$EXP_ROOT/data_index/$(basename "$CONFLICT_JSONL")"
fi

# Prefer live code from bundle (drop any stale empty dirs).
if [[ -n "${PKG_ROOT:-}" ]]; then
  rm -rf "$EXP_ROOT/$(basename "$PKG_ROOT")"; ln -sfn "$PKG_ROOT" "$EXP_ROOT/$(basename "$PKG_ROOT")"
fi
if [[ -n "${QTY_ROOT:-}" ]]; then
  rm -rf "$EXP_ROOT/$(basename "$QTY_ROOT")"; ln -sfn "$QTY_ROOT" "$EXP_ROOT/$(basename "$QTY_ROOT")"
fi

# Defensive defaults in case paths.env only exported VENV_FLA / VENV_NOFLA.
export FLA_PY="${FLA_PY:-${VENV_FLA:-$BUNDLE_ROOT/00_envs/venv-base}/bin/python}"
export NOFLA_PY="${NOFLA_PY:-${VENV_NOFLA:-$BUNDLE_ROOT/00_envs/venv-nofla}/bin/python}"
export QTY_PY="${QTY_PY:-$FLA_PY}"
export PYTHON_BIN="${PYTHON_BIN:-$FLA_PY}"