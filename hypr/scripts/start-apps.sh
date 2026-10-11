#!/bin/bash

launch() {
    local class="$1"
    local workspace="$2"
    shift 2
    local cmd=("$@")

    local info
    info=$(hyprctl clients -j | jq -r --arg c "$class" 'first(.[] | select(.class == $c)) | "\(.address) \(.workspace.id)"')

    if [[ -z "$info" ]]; then
        hyprctl dispatch "hl.dsp.exec_cmd('${cmd[*]}', { workspace = '${workspace} silent' })"
    else
        local addr cur_ws
        read -r addr cur_ws <<< "$info"
        if [[ "$cur_ws" != "$workspace" ]]; then
            hyprctl dispatch "hl.dsp.window.move({ window = 'address:${addr}', workspace = '${workspace}', follow = false })"
        fi
    fi
}

close_others() {
    local known='["code","firefox","slack","beekeeper-studio","Spotify"]'
    hyprctl clients -j | jq -r --argjson known "$known" \
        '.[] | select(.class as $c | $known | index($c) == null) | .address' | \
    while read -r addr; do
        hyprctl dispatch "hl.dsp.window.close({ window = 'address:${addr}' })"
    done
}

launch "code"             1  code
launch "firefox"          2  firefox
launch "beekeeper-studio" 3  flatpak run io.beekeeperstudio.Studio
launch "slack"            4  slack
launch "Spotify"          5  spotify

close_others
