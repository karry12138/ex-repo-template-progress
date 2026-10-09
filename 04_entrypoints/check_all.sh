#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

echo "===== check_all ====="
echo "BUNDLE_ROOT=$BUNDLE_ROOT"
echo "EXP_ROOT=$EXP_ROOT"
echo "MODEL=$MODEL"
echo "FLA_PY=$FLA_PY"
echo "NOFLA_PY=$NOFLA_PY"

fail=0
need() {
  local p="$1"; local label="${2:-$1}";
  if [[ -e "$p" ]]; then echo "[OK]   $label";
  else echo "[MISS] $label ($p)"; fail=1; fi;
}

# The checks below are TEMPLATE defaults.  Edit them to match your assets.
need "$MODEL" "MODEL"
need "${ADAPTER_DIR:-}" "ADAPTER_DIR"
need "$DATASET" "DATASET (full index)"
need "$PKG_ROOT" "PKG_ROOT (sweep package)"
need "$QTY_ROOT" "QTY_ROOT (main package)"
need "$FLA_PY" "FLA python"
need "$NOFLA_PY" "noFLA python"

echo "----- FLA env (venv-base) -----"
if [[ -x "$FLA_PY" ]]; then
  "$FLA_PY" - <<'PY' || fail=1
import torch
print("torch", torch.__version__)
print("cuda", torch.cuda.is_available())
PY
fi

echo "----- noFLA env (venv-nofla must BLOCK accel kernels) -----"
if [[ -x "$NOFLA_PY" ]]; then
  "$NOFLA_PY" - <<'PY' || fail=1
import importlib
for pkg in ("fla", "causal_conv1d"):
    try:
        importlib.import_module(pkg)
    except ImportError as e:
        print(pkg, "blocked:", e)
    else:
        raise SystemExit(f"{pkg} should be blocked in venv-nofla")
print("venv-nofla OK")
PY
fi

if [[ "$fail" -ne 0 ]]; then
  echo "[FAIL] missing assets — see MISS lines / docs/REPRODUCE.md"
  exit 1;
fi
echo "[PASS] ready to reproduce"
