#!/usr/bin/env bash

##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
# Github    : https://github.com/buildra
# SF        : https://sourceforge.net/projects/kiro/files/
##################################################################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
# Script to import GTK settings from:
#   ~/.config/gtk-3.0/settings.ini
#
# It applies:
#   - GTK theme
#   - Icon theme
#   - Cursor theme
#   - Font name
#
##################################################################################################################

set -e

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
GNOME_SCHEMA="org.gnome.desktop.interface"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Cannot find $CONFIG_FILE"
    exit 1
fi

# Check if gsettings exists
if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings is not installed"
    exit 1
fi

get_setting() {
    local key="$1"
    grep "^${key}=" "$CONFIG_FILE" | head -n 1 | cut -d'=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

GTK_THEME="$(get_setting "gtk-theme-name")"
ICON_THEME="$(get_setting "gtk-icon-theme-name")"
CURSOR_THEME="$(get_setting "gtk-cursor-theme-name")"
FONT_NAME="$(get_setting "gtk-font-name")"

[ -n "$GTK_THEME" ] && gsettings set "$GNOME_SCHEMA" gtk-theme "$GTK_THEME"
[ -n "$ICON_THEME" ] && gsettings set "$GNOME_SCHEMA" icon-theme "$ICON_THEME"
[ -n "$CURSOR_THEME" ] && gsettings set "$GNOME_SCHEMA" cursor-theme "$CURSOR_THEME"
[ -n "$FONT_NAME" ] && gsettings set "$GNOME_SCHEMA" font-name "$FONT_NAME"

echo "GTK settings imported successfully"