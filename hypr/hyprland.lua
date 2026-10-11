-- See https://wiki.hypr.land/Configuring/

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-2",     mode = "1920x1080@144.00101", position = "0x0",    scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60.00000",  position = "1920x0", scale = 1 })

-- Workspace to monitor assignments
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia") -- NVIDIA hardware video acceleration

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sh -c 'until awww query >/dev/null 2>&1; do sleep 0.2; done; awww img ~/.config/hypr/wallpaper.jpg'")
    hl.exec_cmd("swaync --config ~/.config/swaync/config.json")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("waybar")
    hl.exec_cmd("wayscriber --daemon")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    input = {
        kb_layout    = "be",
        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        col = {
            active_border   = "rgb(fab387)",
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    misc = {
        disable_hyprland_logo = true,
        middle_click_paste    = false,
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.10, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    -- Ignore maximize requests from all apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local function bind(keys, dsp, opts)
    hl.bind(mainMod .. " + " .. keys, dsp, opts)
end

bind("C", hl.dsp.exec_cmd("kitty"))                                -- open the terminal
bind("Q", hl.dsp.window.close())                                   -- close the active window
bind("F", hl.dsp.window.fullscreen())                              -- fullscreen active window
bind("L", hl.dsp.exec_cmd("swaylock"))                             -- lock the screen
bind("M", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))       -- show the logout window
bind("SHIFT + M", hl.dsp.exit())                                   -- exit Hyprland
bind("E", hl.dsp.exec_cmd("thunar"))                               -- file browser
bind("V", hl.dsp.window.float({ action = "toggle" }))              -- toggle floating
bind("SPACE", hl.dsp.exec_cmd("wofi"))                             -- app launcher
bind("P", hl.dsp.window.pseudo())                                  -- dwindle
bind("S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))   -- take a screenshot
bind("SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))           -- take a region screenshot
bind("SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))         -- toggle control center
bind("W", hl.dsp.exec_cmd("~/.config/hypr/scripts/start-apps.sh"))
hl.bind("ALT + V", hl.dsp.exec_cmd("cliphist list | wofi -dmenu | cliphist decode | wl-copy")) -- clipboard manager

-- Send the active window to / back from the "magic" special workspace
bind("X", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

-- Move focus with mainMod + arrow keys
bind("left",  hl.dsp.focus({ direction = "left" }))
bind("right", hl.dsp.focus({ direction = "right" }))
bind("up",    hl.dsp.focus({ direction = "up" }))
bind("down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces / move active window, Belgian AZERTY number row
local workspaceKeys = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "section", "egrave", "exclam", "ccedilla", "agrave",
}
for i, key in ipairs(workspaceKeys) do
    bind(key,               hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Wayscriber: draw-over-screen overlay (both keys just toggle show/hide)
hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))
hl.bind("SUPER + ALT + Q", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))

require("media-binds")
