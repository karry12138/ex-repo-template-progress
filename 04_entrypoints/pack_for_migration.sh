#!/usr/bin/env bash
# Pack this repo for USB / rsync migration.
# Default: light pack (code+ckpt+data_index+results+venv-nofla thin + symlinks).
# --full: also copy venv-base, model, image datasets.  TEMPLATE: edit the
#          "full copy" section below to list your real heavy assets.
set -euo pipefail
BUNDLE_ROOT=$(cd "$(dirname "$0")/.." && pwd)
MODE=light
DEST=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --full) MODE=full; shift ;;
    --dest) DEST="$2"; shift 2 ;;
    *) echo "Usage: $0 [--full] [--dest /path/to/outdir]"; exit 2 ;;
  esac
done
DEST=${DEST:-$BUNDLE_ROOT/../$REPO-pb-$(date +%Y%m%d)}
mkdir -p "$DEST"

echo "[pack] mode=$MODE dest=$DEST"
rsync -a --delete \
  --exclude 'work/' \
  --exclude '06_external_links/' \
  --exclude '00_envs/venv-base' \
  "$BUNDLE_ROOT/" "$DEST/"

mkdir -p "$DEST/06_external_links" "$DEST/00_envs"
cp -a "$BUNDLE_ROOT/docs/"* "$DEST/docs/" 2>/dev/null || true

# TEMPLATE: edit these source paths to your real heavy assets.
if [[ "$MODE" == "full" ]]; then
  echo "[pack] copying venv-base (~5.7G)..."
  rsync -a "$(readlink -f "$BUNDLE_ROOT/00_envs/venv-base")/" "$DEST/00_envs/venv-base/"
  echo "[pack] copying model (~19G)..."
  rsync -a "$(readlink -f "$BUNDLE_ROOT/06_external_links/<MODEL_NAME>")/" "$DEST/06_external_links/<MODEL_NAME>/"
  echo "[pack] copying image datasets..."
  rsync -a "$(readlink -f "$BUNDLE_ROOT/06_external_links/<DATASET_TRAFFIC>")/" "$DEST/06_external_links/<DATASET_TRAFFIC>/"
  rsync -a "$(readlink -f "$BUNDLE_ROOT/06_external_links/<DATASET_CONFLICT>")/" "$DEST/06_external_links/<DATASET_CONFLICT>/"
  bash "$DEST/04_entrypoints/fixup_venvs.sh"
else
  cat > "$DEST/06_external_links/README.md" <<'EOF'
# External heavy assets (not in light pack)

On the source machine these are symlinks. For a self-contained USB pack run:

```bash
bash 04_entrypoints/pack_for_migration.sh --full --dest /media/usb/<repo-name>
```

Required absolute sources on this host (edit for your machine):
- model: <ABS_MODEL_PATH>
- venv-base: <ABS_VENV_BASE_PATH>
- traffic images: <ABS_DATASET_TRAFFIC_PATH>
- conflict images: <ABS_DATASET_CONFLICT_PATH>
EOF
  ln -sfn "<ABS_VENV_BASE_PATH>" "$DEST/00_envs/venv-base" || true
fi

cp -a "$BUNDLE_ROOT/paths.env.example" "$DEST/paths.env"
du -sh "$DEST"
echo "[pack] done -> $DEST"
echo "Next on new machine: edit paths.env if needed -> bash 04_entrypoints/fixup_venvs.sh -> bash 04_entrypoints/check_all.sh"