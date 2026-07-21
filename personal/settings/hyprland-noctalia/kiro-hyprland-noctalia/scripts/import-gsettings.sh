#!/usr/bin/env bash
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Import GTK appearance from ~/.config/gtk-3.0/settings.ini into the
#   org.gnome.desktop.interface gsettings schema (theme, icons, cursor,
#   font), so GTK4/libadwaita apps and tools that read gsettings pick up
#   the Kiro look on a Hyprland (Wayland) session.
# Why:
#   On Wayland there is no xsettings daemon; many apps read gsettings
#   instead of settings.ini, so we mirror the .ini values into gsettings
#   at session start.
#####################################################################

set -euo pipefail

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
GNOME_SCHEMA="org.gnome.desktop.interface"

[ -f "$CONFIG_FILE" ] || { echo "Cannot find $CONFIG_FILE"; exit 0; }
command -v gsettings >/dev/null 2>&1 || { echo "gsettings not installed"; exit 0; }

get_setting() {
    grep "^${1}=" "$CONFIG_FILE" | head -n 1 | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

GTK_THEME="$(get_setting gtk-theme-name)"
ICON_THEME="$(get_setting gtk-icon-theme-name)"
CURSOR_THEME="$(get_setting gtk-cursor-theme-name)"
FONT_NAME="$(get_setting gtk-font-name)"

[ -n "$GTK_THEME" ]    && gsettings set "$GNOME_SCHEMA" gtk-theme   "$GTK_THEME"
[ -n "$ICON_THEME" ]   && gsettings set "$GNOME_SCHEMA" icon-theme  "$ICON_THEME"
[ -n "$CURSOR_THEME" ] && gsettings set "$GNOME_SCHEMA" cursor-theme "$CURSOR_THEME"
[ -n "$FONT_NAME" ]    && gsettings set "$GNOME_SCHEMA" font-name   "$FONT_NAME"
gsettings set "$GNOME_SCHEMA" color-scheme "prefer-dark"

echo "GTK settings imported into gsettings"
