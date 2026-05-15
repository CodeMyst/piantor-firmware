#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QMK_DIR="$REPO_ROOT/qmk_firmware"
KEYBOARD_SRC="$REPO_ROOT/keyboards/beekeeb/piantor_weact"
KEYBOARD_DST="$QMK_DIR/keyboards/beekeeb/piantor_weact"

echo "== Piantor firmware setup =="

# 1. Ensure submodule is initialized
if [ ! -d "$QMK_DIR/.git" ]; then
  echo "[1/4] Initializing QMK submodule..."
  git submodule update --init --recursive
else
  echo "[1/4] QMK submodule already initialized"
fi

# 2. Check keyboard source exists
if [ ! -d "$KEYBOARD_SRC" ]; then
  echo "ERROR: Keyboard source not found at:"
  echo "  $KEYBOARD_SRC"
  exit 1
fi

# 3. Copy config into QMK tree
echo "[2/4] Copying keyboard into QMK tree..."

mkdir -p "$(dirname "$KEYBOARD_DST")"

if [ -L "$KEYBOARD_DST" ] || [ -d "$KEYBOARD_DST" ]; then
  echo "  removing existing keyboard link/copy"
  rm -rf "$KEYBOARD_DST"
fi

cp -r "$KEYBOARD_SRC" "$KEYBOARD_DST"

echo "  copied:"
echo "    $KEYBOARD_SRC -> $KEYBOARD_DST"

# 4. Optional: install udev rules
echo "[3/4] Installing QMK udev rules (optional)..."

if [ -f "$QMK_DIR/util/install_udev.sh" ]; then
  echo "  requires sudo"
  sudo bash "$QMK_DIR/util/install_udev.sh" || true
else
  echo "  skipped (no installer found)"
fi

# 5. sanity check
echo "[4/4] Sanity check..."

if make -C "$QMK_DIR" list-keyboards | grep -q "beekeeb/piantor_weact"; then
  echo "  OK: keyboard visible to QMK"
else
  echo "  WARNING: keyboard not detected in QMK list"
fi

echo ""
echo "Setup complete."
echo ""
echo "Build command:"
echo "  make -C qmk beekeeb/piantor_weact:vial"
