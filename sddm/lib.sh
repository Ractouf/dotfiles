# Shared helpers for apply.sh and preview.sh (sourced)

SDDM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/sddm"

current_theme() {
    tr -d '[:space:]' < "$SDDM_DIR/current"
}

# Print the directory of theme $1: a folder in this repo, or a themes.conf entry (cloned/updated)
theme_dir() {
    local name="$1" url subdir ref
    if [[ -f "$SDDM_DIR/$name/metadata.desktop" ]]; then
        echo "$SDDM_DIR/$name"
        return
    fi

    read -r _ url subdir ref < <(awk -v n="$name" '$1 == n' "$SDDM_DIR/themes.conf")
    if [[ -z "${url:-}" ]]; then
        echo "Unknown theme '$name': not in $SDDM_DIR or themes.conf" >&2
        return 1
    fi

    local repo="$SDDM_CACHE/$name"
    if [[ -d "$repo/.git" ]]; then
        git -C "$repo" pull -q --ff-only >&2 || echo "Could not update $repo, using it as is" >&2
    else
        git clone -q --depth 1 ${ref:+--branch "$ref"} "$url" "$repo" >&2 || return 1
    fi
    echo "$repo/${subdir:-.}"
}
