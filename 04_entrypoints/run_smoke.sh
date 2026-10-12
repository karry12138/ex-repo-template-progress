#!/usr/bin/env bash
# 小样本冒烟：确认路径、解释器和入口能跑通。
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

export MAX_SAMPLES="${MAX_SAMPLES:-1}"
export OUTPUT_PATH="${OUTPUT_PATH:-$EXP_ROOT/outputs/smoke_$(date +%Y%m%d_%H%M%S).json}"
mkdir -p "$(dirname "$OUTPUT_PATH")"

echo ">>> smoke  MAX_SAMPLES=$MAX_SAMPLES  PYTHON_BIN=${PYTHON_BIN:-}"
echo ">>> OUTPUT_PATH=$OUTPUT_PATH"

# "$PYTHON_BIN" "$CODE_ROOT/<入口脚本>.py" --max-samples "$MAX_SAMPLES" --output "$OUTPUT_PATH"

echo "TODO: 编辑 04_entrypoints/run_smoke.sh，填入实际冒烟命令"
