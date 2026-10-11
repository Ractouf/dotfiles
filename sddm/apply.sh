#!/bin/bash
# Install the theme from this repo as the system SDDM theme.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME=sugar-candy
DEST="/usr/share/sddm/themes/$NAME"

wallpaper="$DIR/../hypr/wallpaper.jpg"
[[ -e "$wallpaper" ]] || wallpaper="$DIR/../hypr/wallpaper.template.jpg"

sudo rm -rf "$DEST"
sudo cp -r "$DIR/$NAME" "$DEST"
sudo rm -f "$DEST/Backgrounds/wallpaper.jpg"  # preview.sh link into $HOME
sudo install -Dm644 "$wallpaper" "$DEST/Backgrounds/wallpaper.jpg"

sudo install -Dm644 /dev/stdin /etc/sddm.conf.d/10-theme.conf <<EOF
[Theme]
Current=$NAME
EOF
sudo install -Dm644 /dev/stdin /etc/sddm.conf.d/numlock.conf <<'EOF'
[General]
Numlock=on
EOF

echo "Installed $DEST, active at next login."
