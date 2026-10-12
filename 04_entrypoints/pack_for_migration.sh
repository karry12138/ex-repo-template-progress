#!/usr/bin/env bash
# 打包以便 rsync / 拷贝到另一台机器。
# 默认 light：源码、检查点、数据索引、结果、文档；不含 work/ 与重型资产实体。
# --full：额外拷贝 venv、MODEL_DIR、DATA_DIR（读 paths.env；占位符或缺失则跳过）。
set -euo pipefail
BUNDLE_ROOT=$(cd "$(dirname "$0")/.." && pwd)
if [[ -f "$BUNDLE_ROOT/paths.env" ]]; then
  # shellcheck disable=SC1091
  source "$BUNDLE_ROOT/paths.env"
elif [[ -f "$BUNDLE_ROOT/paths.env.example" ]]; then
  # shellcheck disable=SC1091
  source "$BUNDLE_ROOT/paths.env.example"
fi

MODE=light
DEST=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --full) MODE=full; shift ;;
    --dest) DEST="$2"; shift 2 ;;
    *) echo "用法: $0 [--full] [--dest /path/to/outdir]"; exit 2 ;;
  esac
done

NAME=$(basename "$BUNDLE_ROOT")
DEST=${DEST:-$BUNDLE_ROOT/../${NAME}-pack-$(date +%Y%m%d)}
mkdir -p "$DEST"

echo "[pack] mode=$MODE dest=$DEST"
rsync -a --delete \
  --exclude '.git/' \
  --exclude 'work/' \
  --exclude '06_external_links/' \
  --exclude '00_envs/venv' \
  "$BUNDLE_ROOT/" "$DEST/"

mkdir -p "$DEST/06_external_links" "$DEST/00_envs" "$DEST/work" "$DEST/docs"
cp -a "$BUNDLE_ROOT/docs/." "$DEST/docs/"
cp -a "$BUNDLE_ROOT/06_external_links/README.md" "$DEST/06_external_links/README.md"
cp -a "$BUNDLE_ROOT/work/README.md" "$DEST/work/README.md"

copy_tree() {
  local src="$1" dest="$2" label="$3"
  if [[ -z "${src:-}" || "$src" == *'<'* ]]; then
    echo "[pack] 跳过 $label（未配置或仍是占位符）"
    return 0
  fi
  if [[ ! -e "$src" ]]; then
    echo "[pack] 跳过 $label（不存在）: $src"
    return 0
  fi
  echo "[pack] 拷贝 $label ..."
  mkdir -p "$dest"
  rsync -a "$(readlink -f "$src")/" "$dest/"
}

if [[ "$MODE" == "full" ]]; then
  copy_tree "${VENV:-$BUNDLE_ROOT/00_envs/venv}" "$DEST/00_envs/venv" "venv"
  copy_tree "${MODEL_DIR:-}" "$DEST/06_external_links/$(basename "${MODEL_DIR:-model}")" "model"
  copy_tree "${DATA_DIR:-}" "$DEST/06_external_links/$(basename "${DATA_DIR:-data}")" "data"
  if [[ -x "$DEST/04_entrypoints/fixup_venv.sh" && -d "$DEST/00_envs/venv" && ! -L "$DEST/00_envs/venv" ]]; then
    bash "$DEST/04_entrypoints/fixup_venv.sh" || echo "[pack] fixup_venv 未完成，到目标机后按提示重跑"
  fi
elif [[ -n "${VENV:-}" && -e "$VENV" ]]; then
  ln -sfn "$(readlink -f "$VENV")" "$DEST/00_envs/venv" || true
fi

if [[ -f "$BUNDLE_ROOT/paths.env" ]]; then
  cp -a "$BUNDLE_ROOT/paths.env" "$DEST/paths.env"
else
  cp -a "$BUNDLE_ROOT/paths.env.example" "$DEST/paths.env"
fi

du -sh "$DEST"
echo "[pack] 完成 -> $DEST"
echo "目标机：按需改 paths.env → bash 04_entrypoints/fixup_venv.sh → bash 04_entrypoints/check_all.sh"
