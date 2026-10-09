#!/usr/bin/env bash
# Generic reproducible run entrypoint.
# TEMPLATE: replace <RUN_COMMAND> with your actual pipeline, and set the env
# vars below to what your pipeline needs.  The contract (BUNDLE_ROOT /
# paths.env / EXP_ROOT) is loaded by _common.sh so scripts stay DRY.
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

# ---- Experiment-specific exports (EDIT ME) ----
export RUN_TAG="${RUN_TAG:-run_$(date +%Y%m%d_%H%M%S)}"
export OUTPUT_DIR="${OUTPUT_DIR:-$EXP_ROOT/outputs/$RUN_TAG}"
export PYTHON_BIN="${PYTHON_BIN:-$FLA_PY}"
export MODEL ADAPTER_DIR DATASET
mkdir -p "$OUTPUT_DIR"

echo ">>> run_experiment  RUN_TAG=$RUN_TAG"
echo ">>> EXP_ROOT=$EXP_ROOT  MODEL=$MODEL  PYTHON_BIN=$PYTHON_BIN"

# ---- Actual pipeline (EDIT ME) ----
# bash "$PKG_ROOT/scripts/<MY_RUN_SCRIPT>.sh"
# "$PYTHON_BIN" "$QTY_ROOT/<MY_INFER_SCRIPT>.py" --input "$DATASET"

echo "TODO: replace <RUN_COMMAND> in 04_entrypoints/run_experiment.sh"
