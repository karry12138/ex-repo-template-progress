#!/usr/bin/env bash
# Generic smoke test: run a tiny slice to confirm the stack is wired.
# TEMPLATE: set MAX_SAMPLES / a small subset and point at your script.
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

export MAX_SAMPLES="${MAX_SAMPLES:-1}"
export ADAPTER_DIR MODEL PYTHON_BIN
export PYTHON_BIN="${PYTHON_BIN:-$FLA_PY}"
export OUTPUT_PATH="${OUTPUT_PATH:-$EXP_ROOT/outputs/smoke_$(date +%Y%m%d_%H%M%S).json}"

echo ">>> smoke  MAX_SAMPLES=$MAX_SAMPLES  PYTHON_BIN=$PYTHON_BIN"
echo "TODO: replace <SMOKE_COMMAND> in 04_entrypoints/run_smoke.sh"
