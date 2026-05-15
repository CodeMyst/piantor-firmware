#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QMK_DIR="$REPO_ROOT/vial-qmk"
KEYBOARD_SRC="$REPO_ROOT/keyboards/beekeeb/piantor_weact"
KEYBOARD_DST="$QMK_DIR/keyboards/beekeeb/piantor_weact"

echo "== Piantor firmware setup =="

# Ensure submodule is initialized
if [ ! -d "$QMK_DIR/.git" ]; then
  echo "[1/4] Initializing Vial QMK submodule..."
  git submodule update --init --recursive
else
  echo "[1/4] Vial QMK submodule already initialized"
fi

# Check keyboard source exists
if [ ! -d "$KEYBOARD_SRC" ]; then
  echo "ERROR: Keyboard source not found at:"
  echo "  $KEYBOARD_SRC"
  exit 1
fi

# Copy config into Vial QMK tree
echo "[2/4] Copying keyboard into Vial QMK tree..."

mkdir -p "$(dirname "$KEYBOARD_DST")"

if [ -L "$KEYBOARD_DST" ] || [ -d "$KEYBOARD_DST" ]; then
  echo "  removing existing keyboard link/copy"
  rm -rf "$KEYBOARD_DST"
fi

cp -r "$KEYBOARD_SRC" "$KEYBOARD_DST"

echo "  copied:"
echo "    $KEYBOARD_SRC -> $KEYBOARD_DST"

# Sanity check
echo "[4/4] Sanity check..."

if make -C "$QMK_DIR" list-keyboards | grep -q "beekeeb/piantor_weact"; then
  echo "  OK: keyboard visible to QMK"
else
  echo "  WARNING: keyboard not detected in Vial QMK list"
fi

echo ""
echo "Setup complete."
echo ""
echo "Build command:"
echo "  make -C vial-qmk beekeeb/piantor_weact:vial"
