-- =============================================================================
-- 1. MONITORS CONFIGURATION
-- =============================================================================
hl.monitor({
    output   = "desc:ASUSTek COMPUTER INC XG27ACS T5LMTF003668",
    mode     = "2560x1440@180",
    position = "1920x0",
    scale    = "1",
})

hl.monitor({
    output   = "desc:AU Optronics B173HAN04.9",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})


-- =============================================================================
-- 2. ENVIRONMENT VARIABLES
-- =============================================================================
hl.env("XCURSOR_THEME", "BreezeX-RosePine-Dark")
hl.env("XCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_SIZE", "36")


-- =============================================================================
-- 3. AUTOSTART APPS
-- =============================================================================
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("waypaper --restore")
end)


-- =============================================================================
-- 4. VISUALS & SYSTEM CONFIG
-- =============================================================================
hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 20,
        border_size      = 2,
        col              = {
            active_border   = { colors = { "#cdd6f4" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 20,
        rounding_power   = 2,
        active_opacity   = 1,
        inactive_opacity = 1,
        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur             = {
            enabled  = true,
            size     = 6,
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

    scrolling = {
        fullscreen_on_one_column = true,
    },

    misc = {
        vrr                     = 1,
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


-- =============================================================================
-- 5. ANIMATIONS CONFIGURATION
-- =============================================================================
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 40, dampening = 13 })

hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, spring = "rubber" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, spring = "rubber", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, spring = "rubber" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, spring = "rubber" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, spring = "rubber" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, spring = "rubber" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, spring = "rubber" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 7, spring = "rubber" })
hl.animation({ leaf = "layers", enabled = true, speed = 5, spring = "rubber", style = "popin 80%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, spring = "rubber", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 5, spring = "rubber" })


-- =============================================================================
-- 6. INPUT & GESTURES
-- =============================================================================
hl.config({
    input = {
        kb_layout     = "us, ru, ua",
        kb_variant    = "",
        kb_model      = "",
        kb_options    = "grp:alt_shift_toggle",
        kb_rules      = "",
        follow_mouse  = 1,
        accel_profile = "flat",
        sensitivity   = 0,
        touchpad      = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


-- =============================================================================
-- 7. WINDOW RULES
-- =============================================================================
local suppressMaximizeRule = hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
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

hl.window_rule({
    match            = {
        class = "^zoom$",
        title = "negative:^Zoom$"
    },
    float            = true,
    no_initial_focus = true,
    no_blur          = true,
    no_shadow        = true,
    no_anim          = true,
    decorate         = false,
})

hl.window_rule({
    name = "waypaper",
    match = { class = "waypaper" },
    float = true
})

hl.window_rule({
    name = "zen_Picture-in-Picture",
    match = { class = "zen-beta", title = "Picture-in-Picture" },
    float = true
})

hl.window_rule({
    name = "Pavucontrol",
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    size = { 800, 600 },
})

hl.window_rule({
    name = "gpick",
    match = { class = "gpick", title = "Gpick" },
    float = true
})


-- =============================================================================
-- 8. PROGRAMS & KEYBINDINGS
-- =============================================================================
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi --show drun"

local mainMod     = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/rofi/launchers/type-6/launcher.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("Print", hl.dsp.exec_cmd([[
    geometry=$(slurp)
    if [ ! -z "$geometry" ]; then
        sleep 0.3
        grim -g "$geometry" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d_%H%M%S').png | wl-copy
    fi
]]))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
