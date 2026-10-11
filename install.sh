#!/bin/bash
# Set up an Arch Linux + Hyprland desktop from this repo.
#
# Usage: ./install.sh [--nvidia] [--apps] [--link-only]
#   --nvidia     also install NVIDIA drivers (packages/nvidia.txt)
#   --apps       also install personal apps (packages/apps*.txt)
#   --link-only  skip packages and system setup, only link configs
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

nvidia=false apps=false link_only=false
for arg in "$@"; do
    case "$arg" in
        --nvidia)    nvidia=true ;;
        --apps)      apps=true ;;
        --link-only) link_only=true ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

[[ $EUID -eq 0 ]] && { echo "Run as your user, not root (sudo is used when needed)." >&2; exit 1; }

pkglist() { grep -vE '^\s*(#|$)' "$DOTFILES/packages/$1"; }

install_packages() {
    sudo pacman -Syu --needed --noconfirm - < <(pkglist pacman.txt)
    $nvidia && sudo pacman -S --needed --noconfirm - < <(pkglist nvidia.txt)
    $apps   && sudo pacman -S --needed --noconfirm - < <(pkglist apps.txt)

    if ! command -v yay >/dev/null; then
        sudo pacman -S --needed --noconfirm git base-devel
        local tmp; tmp="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
    yay -S --needed --noconfirm - < <(pkglist aur.txt)
    $apps && yay -S --needed --noconfirm - < <(pkglist apps-aur.txt)
    return 0
}

# Symlink $1 (in repo) to $2, backing up whatever is there
link() {
    local src="$DOTFILES/$1" dest="$2"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        return
    fi
    if [[ -e "$dest" || -L "$dest" ]]; then
        mv "$dest" "$dest.bak-$STAMP"
        echo "Backed up $dest -> $dest.bak-$STAMP"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "Linked $dest"
}

link_configs() {
    local dir
    [[ -e "$DOTFILES/hypr/wallpaper.jpg" ]] || cp "$DOTFILES/hypr/wallpaper.template.jpg" "$DOTFILES/hypr/wallpaper.jpg"
    for dir in hypr waybar wofi swaync swaylock wlogout kitty fastfetch wayscriber gtk-3.0; do
        link "$dir" "$CONFIG/$dir"
    done
    link starship.toml "$CONFIG/starship.toml"
    link .bashrc "$HOME/.bashrc"
}

setup_system() {
    "$DOTFILES/sddm/apply.sh"
    sudo systemctl enable sddm.service bluetooth.service NetworkManager.service
}

if ! $link_only; then
    install_packages
fi
link_configs
if ! $link_only; then
    setup_system
fi

echo
echo "Done. Before rebooting, check hypr/hyprland.lua for machine-specific settings:"
echo "  - monitor names/modes (run 'hyprctl monitors' once logged in)"
echo "  - LIBVA_DRIVER_NAME=nvidia (remove on non-NVIDIA machines)"
echo "Replace ~/.config/hypr/wallpaper.jpg with your own image (re-run without --link-only to update SDDM)."
