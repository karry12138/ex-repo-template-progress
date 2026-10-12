#!/usr/bin/env bash
# 主实验入口。把下面的 TODO 换成实际命令。
# 仓库根、paths.env、work/ 由 _common.sh 准备好。
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

export RUN_TAG="${RUN_TAG:-run_$(date +%Y%m%d_%H%M%S)}"
export OUTPUT_DIR="${OUTPUT_DIR:-$EXP_ROOT/outputs/$RUN_TAG}"
mkdir -p "$OUTPUT_DIR"

echo ">>> run_experiment  RUN_TAG=$RUN_TAG"
echo ">>> EXP_ROOT=$EXP_ROOT"
echo ">>> MODEL_DIR=${MODEL_DIR:-}  DATA_INDEX=${DATA_INDEX:-}  PYTHON_BIN=${PYTHON_BIN:-}"

# ---- 换成实际流水线 ----
# "$PYTHON_BIN" "$CODE_ROOT/<入口脚本>.py" \
#   --model "$MODEL_DIR" \
#   --data "$DATA_INDEX" \
#   --checkpoint "$CHECKPOINT_DIR" \
#   --output "$OUTPUT_DIR"

echo "TODO: 编辑 04_entrypoints/run_experiment.sh，填入实际命令"
