# dotfiles

Arch Linux + Hyprland desktop: Hyprland (Lua config), Waybar, Wofi, SwayNC, Kitty, swaylock-effects, wlogout, SDDM (Sugar Candy), fastfetch + starship.

## Install

On a fresh Arch install with a user account and network:

```sh
git clone https://github.com/Ractouf/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh            # add --nvidia for NVIDIA drivers, --apps for personal apps
```

The script:

1. Installs packages from `packages/` (`pacman.txt`, then `aur.txt` via yay, which it bootstraps if missing)
2. Symlinks every config into `~/.config` (and `.bashrc` into `~`), backing up anything already there as `*.bak-<timestamp>`
3. Installs the SDDM theme named in `sddm/current` and enables `sddm`, `bluetooth` and `NetworkManager`

`./install.sh --link-only` only (re)creates the symlinks.

Because configs are symlinked, editing `~/.config/...` edits this repo directly.

## Machine-specific settings

Check `hypr/hyprland.lua` before the first login:

- `hl.monitor` / `hl.workspace_rule`: monitor names and modes (`hyprctl monitors`)
- `LIBVA_DRIVER_NAME=nvidia`: remove on non-NVIDIA machines
- `kb_layout = "be"`: keyboard layout
- `hypr/scripts/start-apps.sh` (`SUPER+W`): personal app/workspace layout

## Wallpaper

`install.sh` seeds `hypr/wallpaper.jpg` from `hypr/wallpaper.template.jpg`. Replace it with your own image; it is git-ignored, so it stays local. It is used by Hyprland (via awww) and copied to the SDDM login screen when `install.sh` runs without `--link-only`.

## SDDM theme

`sddm/current` names the login theme `install.sh` applies (currently `minesddm`).

Themes come from two places:

- **Folders in `sddm/`**: themes kept in this repo, e.g. `sddm/sugar-candy/` (a fork of [Sugar Candy](https://framagit.org/MarianArlt/sddm-sugar-candy), GPL-3.0)
- **`sddm/themes.conf`**: other people's themes, cloned on demand into `~/.cache/dotfiles/sddm/<name>` (and updated on each use) instead of copied here, e.g. [MineSDDM](https://github.com/Davi-S/sddm-theme-minesddm)

```sh
sddm/preview.sh [name|dir]   # greeter in test mode (Qt5 or Qt6), reloads on every save
sddm/apply.sh [name]         # install as the system theme (sudo), active at next login
```

Both default to the theme in `sddm/current`. Test mode shows the real UI but cannot log in, and the power buttons do nothing.

To add a theme from GitHub, add a line to `themes.conf`: `name  git-url  folder-containing-metadata.desktop  [branch/tag]`.

## Layout

| Path | Target | What |
|---|---|---|
| `hypr/` | `~/.config/hypr` | Hyprland config, media binds, scripts, wallpaper template |
| `waybar/` | `~/.config/waybar` | Bar config, style, scripts |
| `wofi/` | `~/.config/wofi` | App launcher |
| `swaync/` | `~/.config/swaync` | Notification center |
| `swaylock/` | `~/.config/swaylock` | Lock screen |
| `wlogout/` | `~/.config/wlogout` | Logout menu |
| `kitty/` | `~/.config/kitty` | Terminal (Catppuccin Mocha) |
| `fastfetch/` | `~/.config/fastfetch` | Animated terminal greeting |
| `wayscriber/` | `~/.config/wayscriber` | Screen annotation |
| `gtk-3.0/` | `~/.config/gtk-3.0` | GTK theme (Adwaita-dark, Papirus) |
| `starship.toml` | `~/.config/starship.toml` | Prompt |
| `.bashrc` | `~/.bashrc` | Shell |
| `sddm/` | `/usr/share/sddm/themes/<name>` | Login screen themes, preview/apply scripts |
| `packages/` | | Package lists |

## Keybinds

`SUPER` is the main modifier.

| Keys | Action |
|---|---|
| `SUPER+C` | Terminal (kitty) |
| `SUPER+SPACE` | App launcher (wofi) |
| `SUPER+E` | File manager (thunar) |
| `SUPER+Q` | Close window |
| `SUPER+F` | Fullscreen |
| `SUPER+V` | Toggle floating |
| `SUPER+P` | Pseudotile |
| `SUPER+X` | Send window to / back from scratchpad |
| `SUPER+arrows` | Move focus |
| `SUPER+[&é"'(§è!çà]` | Switch workspace 1-10 (AZERTY) |
| `SUPER+SHIFT+[&é"'(§è!çà]` | Move window to workspace 1-10 |
| `SUPER+S` | Screenshot region to swappy |
| `SUPER+SHIFT+S` | Screenshot region (hyprshot) |
| `ALT+V` | Clipboard history |
| `SUPER+SHIFT+N` | Notification center |
| `SUPER+L` | Lock screen |
| `SUPER+M` | Logout menu |
| `SUPER+SHIFT+M` | Exit Hyprland |
| `SUPER+W` | Launch work apps |
| `SUPER+ALT+D` / `SUPER+ALT+Q` | Toggle wayscriber overlay |
