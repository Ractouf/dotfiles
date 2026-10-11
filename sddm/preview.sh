#!/bin/bash
# Live preview of the SDDM theme: opens the greeter in test mode and reopens it on every save.
# Ctrl+C to stop.
set -u

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$DIR/sugar-candy"

# Show the current Hyprland wallpaper (git-ignored link)
wallpaper="$DIR/../hypr/wallpaper.jpg"
[[ -e "$wallpaper" ]] || wallpaper="$DIR/../hypr/wallpaper.template.jpg"
ln -sfn "$(realpath "$wallpaper")" "$THEME/Backgrounds/wallpaper.jpg"

pid=""
start() {
    sddm-greeter --test-mode --theme "$THEME" &
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
echo "Previewing $THEME, edit any file to reload (Ctrl+C to quit)"

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
