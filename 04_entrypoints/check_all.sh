#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

echo "===== check_all ====="
echo "BUNDLE_ROOT=$BUNDLE_ROOT"
echo "EXP_ROOT=$EXP_ROOT"
echo "MODEL_DIR=${MODEL_DIR:-}"
echo "DATA_DIR=${DATA_DIR:-}"
echo "PYTHON_BIN=${PYTHON_BIN:-}"

fail=0
need() {
  local p="$1" label="${2:-$1}"
  if [[ -n "$p" && -e "$p" ]]; then
    echo "[OK]   $label"
  else
    echo "[MISS] $label ($p)"
    fail=1
  fi
}

# 下列检查是模板默认项。资产不同就改这里，或在 paths.env 里改对应变量。
need "${MODEL_DIR:-}" "MODEL_DIR"
need "${DATA_DIR:-}" "DATA_DIR"
need "${CHECKPOINT_DIR:-}" "CHECKPOINT_DIR"
need "${DATA_INDEX:-}" "DATA_INDEX"
need "${CODE_ROOT:-}" "CODE_ROOT"
need "${PYTHON_BIN:-}" "PYTHON_BIN"

if [[ -n "${PYTHON_BIN:-}" && -x "$PYTHON_BIN" ]]; then
  echo "----- python -----"
  "$PYTHON_BIN" -c 'import sys; print("python", sys.version.split()[0])' || fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  echo "[FAIL] 有资产缺失。占位符未替换时出现 [MISS] 是预期结果。见 docs/REPRODUCE.md"
  exit 1
fi
echo "[PASS] ready"
