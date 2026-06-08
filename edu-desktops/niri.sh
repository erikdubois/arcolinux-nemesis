#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#
#   Exploration install for niri — a scrollable-tiling Wayland compositor (Rust/Smithay).
#   niri ships ONLY a compositor, so this also pulls a minimal usable Wayland stack
#   (bar, launcher, notifications, lock, wallpaper, portal, XWayland) and writes a
#   config.kdl carrying Kiro's keybinding scheme adapted to niri's column model.
#
#   NOTE: Kiro is X11-only by design. This is a personal-exploration script (Wayland),
#   not a shipped Kiro desktop. See Kiro-HQ/KIRO-NIRI-WAYLAND-STUDY.md.
#
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

echo
tput setaf 2
echo "########################################################################"
echo "################### Install niri"
echo "########################################################################"
tput sgr0
echo


list=(
alacritty
brightnessctl
fuzzel
grim
mako
niri
noto-fonts
polkit-gnome
qt5-wayland
qt6-wayland
slurp
swaybg
swayidle
swaylock
thunar
thunar-archive-plugin
thunar-volman
ttf-hack
waybar
wl-clipboard
xdg-desktop-portal-gtk
xorg-xwayland
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    install_packages $name
done

echo
tput setaf 3
echo "########################################################################"
echo "CONFIG"
echo "Writing ~/.config/niri/config.kdl with Kiro keybindings"
echo "########################################################################"
tput sgr0
echo

mkdir -p ~/.config/niri

# never overwrite an existing config — keep a timestamped backup first
if [ -f ~/.config/niri/config.kdl ]; then
    cp -af ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak
    tput setaf 3;echo "Existing config backed up to ~/.config/niri/config.kdl.bak";tput sgr0
fi

cat > ~/.config/niri/config.kdl <<'KDL'
// niri — Kiro exploration config
// Kiro keybinding scheme adapted to niri's scrollable-tiling (column) model.
// Bindings that don't translate to a scrollable compositor (master/stack/gaps)
// are replaced by niri-native column navigation. App/workspace/system binds
// mirror ohmychadwm for muscle-memory consistency.

input {
    keyboard {
        xkb {
            // match Kiro's default — adjust layout to taste (e.g. "be" for AZERTY)
            // layout "us"
        }
    }
    touchpad {
        tap
        natural-scroll
    }
    focus-follows-mouse
}

// Minimal usable Wayland session — niri is compositor-only
spawn-at-startup "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
spawn-at-startup "waybar"
spawn-at-startup "mako"
spawn-at-startup "swaybg" "-c" "#1e1e2e"

prefer-no-csd

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

layout {
    gaps 8
    center-focused-column "never"
    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }
    default-column-width { proportion 0.5; }
    focus-ring {
        width 2
    }
}

environment {
    QT_QPA_PLATFORM "wayland"
    MOZ_ENABLE_WAYLAND "1"
}

binds {
    // ── Help / cheatsheet ──────────────────────────────────────────────
    Mod+Shift+Slash { show-hotkey-overlay; }
    Mod+Ctrl+S      { spawn "kiro-keybindings"; }   // Kiro universal cheatsheet opener

    // ── 1. Applications & Launchers ────────────────────────────────────
    Mod+Return       { spawn "alacritty"; }
    Mod+T            { spawn "alacritty"; }
    Mod+Shift+Return { spawn "thunar"; }
    Mod+E            { spawn "code"; }
    Mod+V            { spawn "pavucontrol"; }
    Mod+R            { spawn "fuzzel"; }             // rofi -> fuzzel (Wayland)
    Mod+Space        { spawn "fuzzel"; }
    Mod+D            { spawn "fuzzel"; }
    Mod+F1           { spawn "vivaldi-stable"; }
    Mod+F2           { spawn "code"; }
    Mod+F3           { spawn "inkscape"; }
    Mod+F4           { spawn "gimp"; }
    Mod+F5           { spawn "meld"; }
    Mod+F6           { spawn "vlc"; }
    Mod+F7           { spawn "virtualbox"; }
    Mod+F8           { spawn "thunar"; }
    Mod+F10          { spawn "spotify"; }

    // ── 2. Window Management ───────────────────────────────────────────
    Mod+F            { fullscreen-window; }
    Mod+Q            { close-window; }
    Mod+Shift+Q      { close-window; }
    Mod+Shift+Space  { toggle-window-floating; }
    Mod+M            { maximize-column; }

    // ── Column navigation (niri scrollable model) ──────────────────────
    Mod+H            { focus-column-left; }
    Mod+L            { focus-column-right; }
    Mod+J            { focus-window-down; }
    Mod+K            { focus-window-up; }
    Mod+Left        { focus-column-left; }
    Mod+Right       { focus-column-right; }
    Mod+Shift+H      { move-column-left; }
    Mod+Shift+L      { move-column-right; }
    Mod+Shift+J      { move-window-down; }
    Mod+Shift+K      { move-window-up; }
    Mod+Comma        { consume-window-into-column; }
    Mod+Period       { expel-window-from-column; }
    Mod+BracketLeft  { focus-monitor-left; }
    Mod+BracketRight { focus-monitor-right; }

    // ── 3. Workspaces ──────────────────────────────────────────────────
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }
    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }
    Mod+Shift+6 { move-column-to-workspace 6; }
    Mod+Shift+7 { move-column-to-workspace 7; }
    Mod+Shift+8 { move-column-to-workspace 8; }
    Mod+Shift+9 { move-column-to-workspace 9; }
    Mod+Tab          { focus-workspace-down; }
    Mod+Page_Down    { focus-workspace-down; }
    Mod+Page_Up      { focus-workspace-up; }

    // ── 4. Column width (niri equivalent of master sizing) ─────────────
    Mod+Minus        { set-column-width "-10%"; }
    Mod+Equal        { set-column-width "+10%"; }
    Mod+W            { switch-preset-column-width; }

    // ── 6. Multimedia & Hardware ───────────────────────────────────────
    XF86AudioRaiseVolume allow-when-locked=true { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%"; }
    XF86AudioMute        allow-when-locked=true { spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"; }
    XF86AudioPlay        allow-when-locked=true { spawn "playerctl" "play-pause"; }
    XF86AudioNext        allow-when-locked=true { spawn "playerctl" "next"; }
    XF86AudioPrev        allow-when-locked=true { spawn "playerctl" "previous"; }
    XF86AudioStop        allow-when-locked=true { spawn "playerctl" "stop"; }
    XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "5%+"; }
    XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

    // ── 7. Screenshots ─────────────────────────────────────────────────
    Print            { screenshot; }
    Ctrl+Print       { screenshot-screen; }
    Mod+U            { screenshot; }

    // ── 8. System & Session ────────────────────────────────────────────
    Mod+X            { spawn "swaylock"; }            // X11 archlinux-logout n/a on Wayland
    Mod+Alt+L        { spawn "swaylock"; }
    Mod+Shift+E      { quit; }
    Mod+Shift+P      { power-off-monitors; }
}

// X11 apps run via XWayland automatically (xorg-xwayland installed).
KDL

echo
tput setaf 3
echo "########################################################################"
echo "WAYBAR"
echo "Writing ~/.config/waybar/{config.jsonc,style.css} for niri"
echo "########################################################################"
tput sgr0
echo

mkdir -p ~/.config/waybar

# never overwrite an existing waybar config — keep timestamped backups first
if [ -f ~/.config/waybar/config.jsonc ]; then
    cp -af ~/.config/waybar/config.jsonc ~/.config/waybar/config.jsonc.bak
    tput setaf 3;echo "Existing config.jsonc backed up to config.jsonc.bak";tput sgr0
fi
if [ -f ~/.config/waybar/style.css ]; then
    cp -af ~/.config/waybar/style.css ~/.config/waybar/style.css.bak
    tput setaf 3;echo "Existing style.css backed up to style.css.bak";tput sgr0
fi

cat > ~/.config/waybar/config.jsonc <<'JSONC'
// waybar — niri (Kiro exploration)
// Uses Waybar's native niri/* modules so the bar tracks niri workspaces + window.
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 6,
    "margin-top": 4,
    "margin-left": 8,
    "margin-right": 8,

    "modules-left": ["niri/workspaces", "niri/window"],
    "modules-center": ["clock"],
    "modules-right": ["tray", "pulseaudio", "network", "cpu", "memory", "battery"],

    "niri/workspaces": {
        "format": "{index}",
        "on-click": "activate"
    },
    "niri/window": {
        "format": "{title}",
        "max-length": 70,
        "separate-outputs": true
    },
    "clock": {
        "format": "{:%a %d %b  %H:%M}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    },
    "tray": {
        "icon-size": 16,
        "spacing": 8
    },
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "muted",
        "format-icons": { "default": ["", "", ""] },
        "on-click": "pavucontrol"
    },
    "network": {
        "format-wifi": "  {signalStrength}%",
        "format-ethernet": "  {ipaddr}",
        "format-disconnected": "  off",
        "tooltip-format": "{ifname} {ipaddr}"
    },
    "cpu": {
        "format": "  {usage}%"
    },
    "memory": {
        "format": "  {percentage}%"
    },
    "battery": {
        "format": "{icon} {capacity}%",
        "format-charging": "  {capacity}%",
        "format-icons": ["", "", "", "", ""],
        "states": { "warning": 30, "critical": 15 }
    }
}
JSONC

cat > ~/.config/waybar/style.css <<'CSS'
/* waybar — niri (Kiro exploration). Catppuccin Mocha to match config.kdl bg. */
* {
    font-family: "JetBrainsMono Nerd Font", "Hack", monospace;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: transparent;
    color: #cdd6f4;
}

.modules-left,
.modules-center,
.modules-right {
    background: #1e1e2e;
    border-radius: 10px;
    padding: 0 8px;
}

#workspaces button {
    padding: 0 8px;
    color: #6c7086;
    background: transparent;
}
#workspaces button.active {
    color: #1e1e2e;
    background: #89b4fa;
    border-radius: 8px;
}
#workspaces button.urgent {
    color: #1e1e2e;
    background: #f38ba8;
    border-radius: 8px;
}

#window { color: #a6adc8; padding: 0 6px; }
#clock { color: #89b4fa; padding: 0 10px; font-weight: bold; }

#pulseaudio,
#network,
#cpu,
#memory,
#battery,
#tray {
    padding: 0 8px;
    color: #cdd6f4;
}

#battery.warning  { color: #f9e2af; }
#battery.critical { color: #f38ba8; }
#pulseaudio.muted { color: #6c7086; }
#network.disconnected { color: #6c7086; }
CSS

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
echo "Log in to the 'niri' session from your display manager to explore."
echo
