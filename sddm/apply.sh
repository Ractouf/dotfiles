#!/bin/bash
# Install an SDDM theme as the system theme.
# Usage: apply.sh [name]   (default: the theme named in sddm/current)
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

NAME="${1:-$(current_theme)}"
SRC="$(theme_dir "$NAME")"
DEST="/usr/share/sddm/themes/$NAME"

sudo rm -rf "$DEST"
sudo cp -r "$SRC" "$DEST"
sudo rm -rf "$DEST/.git"

sudo install -Dm644 /dev/stdin /etc/sddm.conf.d/10-theme.conf <<EOF
[Theme]
Current=$NAME
EOF
sudo install -Dm644 /dev/stdin /etc/sddm.conf.d/numlock.conf <<'EOF'
[General]
Numlock=on
EOF

echo "Installed $DEST, active at next login."
