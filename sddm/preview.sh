#!/bin/bash
# Live preview of an SDDM theme: opens the greeter in test mode and reopens it on every save.
# Usage: preview.sh [theme-dir]   (default: sddm/sugar-candy)
# Ctrl+C to stop.
set -u

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$(realpath "${1:-$DIR/sugar-candy}")"

[[ -f "$THEME/metadata.desktop" ]] || { echo "Not an SDDM theme: $THEME" >&2; exit 1; }

# Qt6 themes declare QtVersion=6 and need the Qt6 greeter
greeter=sddm-greeter
grep -qE '^QtVersion=6' "$THEME/metadata.desktop" && greeter=sddm-greeter-qt6

# Our theme shows the current Hyprland wallpaper (git-ignored link)
if [[ "$THEME" == "$DIR/sugar-candy" ]]; then
    wallpaper="$DIR/../hypr/wallpaper.jpg"
    [[ -e "$wallpaper" ]] || wallpaper="$DIR/../hypr/wallpaper.template.jpg"
    ln -sfn "$(realpath "$wallpaper")" "$THEME/Backgrounds/wallpaper.jpg"
fi

pid=""
start() {
    "$greeter" --test-mode --theme "$THEME" &
    pid=$!
}
stop() {
    [[ -n "$pid" ]] && kill "$pid" 2>/dev/null && wait "$pid" 2>/dev/null
    pid=""
}
stamp() {
    find "$THEME" -type f -printf '%T@ %p\n' | sort | md5sum
}
trap 'stop; exit' INT TERM

start
last="$(stamp)"
echo "Previewing $THEME with $greeter, edit any file to reload (Ctrl+C to quit)"

while sleep 0.5; do
    now="$(stamp)"
    if [[ "$now" != "$last" ]]; then
        last="$now"
        echo "Change detected, reloading"
        stop
        start
    elif [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
        echo "Greeter exited, waiting for changes (Ctrl+C to quit)"
        pid=""
    fi
done
