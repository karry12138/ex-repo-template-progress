#!/usr/bin/env bash
# 迁移后检查 00_envs/venv。
# - symlink：打印目标，不改内容。
# - 实体拷贝：若 pyvenv.cfg 的 home 已失效，用 PYTHON_BASE 重写。
#   PYTHON_BASE 是「含 python 可执行文件的目录」，例如 /usr/bin。
set -euo pipefail
BUNDLE_ROOT=$(cd "$(dirname "$0")/.." && pwd)
VENV="$BUNDLE_ROOT/00_envs/venv"

if [[ ! -e "$VENV" ]]; then
  echo "[fixup] 没有 $VENV。请创建，或 symlink 到已有环境。见 docs/REPRODUCE.md" >&2
  exit 2
fi

if [[ -L "$VENV" ]]; then
  target=$(readlink -f "$VENV" || true)
  echo "[fixup] venv 是 symlink -> ${target:-（目标不存在）}"
  if [[ ! -x "$VENV/bin/python" ]]; then
    echo "[fixup] 链接失效。请改指向，或用 pack_for_migration.sh --full 拷贝实体。" >&2
    exit 2
  fi
  echo "[fixup] python: $("$VENV/bin/python" -c 'import sys; print(sys.version.split()[0])')"
  exit 0
fi

cfg="$VENV/pyvenv.cfg"
py="$VENV/bin/python"
if [[ ! -f "$cfg" || ! -e "$py" ]]; then
  echo "[fixup] $VENV 不像一个完整虚拟环境（缺少 pyvenv.cfg 或 bin/python）" >&2
  exit 2
fi

home_path=$(sed -n 's/^home = //p' "$cfg" | head -1)
home_ok=0
if [[ -n "$home_path" && ( -x "$home_path/python" || -x "$home_path/python3" ) ]]; then
  home_ok=1
fi

if [[ "$home_ok" -eq 1 ]]; then
  echo "[fixup] pyvenv.cfg home 仍有效: $home_path"
else
  if [[ -z "${PYTHON_BASE:-}" ]]; then
    echo "[fixup] pyvenv.cfg home 已失效: ${home_path:-<空>}" >&2
    echo "[fixup] 请指定基础解释器所在目录后重跑，例如：" >&2
    echo "         PYTHON_BASE=/usr/bin bash 04_entrypoints/fixup_venv.sh" >&2
    exit 2
  fi
  if [[ ! -x "$PYTHON_BASE/python" && ! -x "$PYTHON_BASE/python3" ]]; then
    echo "[fixup] PYTHON_BASE 下没有 python: $PYTHON_BASE" >&2
    exit 2
  fi
  tmp=$(mktemp)
  awk -v home="$PYTHON_BASE" '
    BEGIN { done = 0 }
    /^home = / { print "home = " home; done = 1; next }
    { print }
    END { if (!done) print "home = " home }
  ' "$cfg" > "$tmp"
  mv "$tmp" "$cfg"
  echo "[fixup] 已把 home 改成 $PYTHON_BASE"
fi

if [[ ! -x "$py" ]]; then
  echo "[fixup] $py 不可执行。虚拟环境可能还需按目标机重装。" >&2
  exit 2
fi
echo "[fixup] python: $("$py" -c 'import sys; print(sys.version.split()[0])')"
