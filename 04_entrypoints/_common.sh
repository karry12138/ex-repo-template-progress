#!/usr/bin/env bash
# 定位仓库根并加载 paths.env。所有入口脚本 source 本文件。
# 目录约定：
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

export EXP_ROOT="${EXP_ROOT:-$BUNDLE_ROOT/work}"
export VENV="${VENV:-$BUNDLE_ROOT/00_envs/venv}"
export PYTHON_BIN="${PYTHON_BIN:-$VENV/bin/python}"

mkdir -p "$EXP_ROOT"/{outputs,logs,reports,tmp}

# 按当前配置重建 symlink。只删除这些目录里已有的链接，避免换名字后留下旧实验路径。
refresh_links() {
  local dest_dir="$1"
  shift
  mkdir -p "$dest_dir"
  find "$dest_dir" -mindepth 1 -maxdepth 1 -type l -exec rm -f {} +
  local src
  for src in "$@"; do
    [[ -n "$src" ]] || continue
    ln -sfn "$src" "$dest_dir/$(basename "$src")"
  done
}

_ckpt=()
[[ -n "${CHECKPOINT_DIR:-}" ]] && _ckpt+=("$CHECKPOINT_DIR")
refresh_links "$EXP_ROOT/checkpoints" "${_ckpt[@]+"${_ckpt[@]}"}"

_indexes=()
_names=$(compgen -v DATA_INDEX || true)
for _name in $_names; do
  [[ -n "${!_name:-}" ]] && _indexes+=("${!_name}")
done
refresh_links "$EXP_ROOT/data_index" "${_indexes[@]+"${_indexes[@]}"}"

_names=$(compgen -v CODE_ROOT || true)
for _name in $_names; do
  _src="${!_name:-}"
  [[ -n "$_src" ]] || continue
  rm -rf "$EXP_ROOT/$(basename "$_src")"
  ln -sfn "$_src" "$EXP_ROOT/$(basename "$_src")"
done
unset _names _name _src _ckpt _indexes
