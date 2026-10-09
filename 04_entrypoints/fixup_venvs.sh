#!/usr/bin/env bash
# After copying the repo to a new machine, rewrite venv-nofla -> venv-base links.
# TEMPLATE: adjust python version / sitecustomize content for your kernels.
set -euo pipefail
BUNDLE_ROOT=$(cd "$(dirname "$0")/.." && pwd)
BASE="$BUNDLE_ROOT/00_envs/venv-base"
NOFLA="$BUNDLE_ROOT/00_envs/venv-nofla"
PYVER="${PYVER:-3.10}"

if [[ ! -x "$BASE/bin/python" ]]; then
  echo "[fixup] missing $BASE/bin/python — copy/rsync venv-base first (see docs/REPRODUCE.md)" >&2
  exit 2;
fi

if [[ -L "$BASE" ]]; then
  echo "[fixup] venv-base is a symlink -> $(readlink -f "$BASE")"
  echo "[fixup] For offline migration, replace with a real copy via pack_for_migration.sh --full"
fi

mkdir -p "$NOFLA/bin"
ln -sfn "$BASE/bin/python" "$NOFLA/bin/python"
ln -sfn python "$NOFLA/bin/python3"
ln -sfn python "$NOFLA/bin/python$PYVER"

cat > "$NOFLA/pyvenv.cfg" <<EOF
home = $BASE/bin
include-system-site-packages = false
version = $PYVER
EOF

# Ensure sitecustomize exists
SITE=$(echo "$NOFLA"/lib/python*/site-packages)
mkdir -p "$SITE"
if [[ ! -f "$SITE/sitecustomize.py" ]]; then
  cat > "$SITE/sitecustomize.py" <<'PY'
"""Hard-block accel kernels in the noFLA venv."""
from __future__ import annotations
import sys

class _BlockImports:
    _blocked = {"fla", "causal_conv1d"}
    def find_spec(self, name, path=None, target=None):  # noqa: ARG002
        root = name.split(".", 1)[0]
        if root in self._blocked:
            raise ImportError(f"venv-nofla blocked import of {name}")
        return None

sys.meta_path.insert(0, _BlockImports())
PY
fi

echo "[fixup] done. Test:"
"$NOFLA/bin/python" -c 'import importlib; importlib.import_module("fla")' 2>&1 | head -2 || true
"$BASE/bin/python" -c 'import fla; print("fla", fla.__version__)'
