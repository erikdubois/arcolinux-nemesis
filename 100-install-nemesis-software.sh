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

##################################################################################################################################
# Purpose
# - Install Erik's core Nemesis software set from nemesis_repo
# - Includes archlinux-tweak-tool-gtk4, alacritty-tweak-tool, archlinux-logout-gtk4, edu-* themes and configs
# - Adds icon themes (neo-candy, surfn), rofi + rofi-themes, flameshot, wttr, lastpass, gittyup, hardcode-fixer
# - Ensure a readable vconsole font exists before installing
# - Install pamac-aur on non-Manjaro systems (avoids conflict with Manjaro's bundled pamac)
##################################################################################################################################

# Load shared helper functions
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

# Log current script
log_section "Running $(script_name)"

# Pause when debug mode is enabled
pause_if_debug

# Ensure a readable console font exists
ensure_vconsole_font

# Install main Nemesis software set
install_nemesis_software() {
    install_packages \
        mkinitcpio-firmware \
        upd72020x-fw \
        archlinux-tweak-tool-gtk4-git \
        alacritty-tweak-tool-git \
        kiro-dot-files \
        arc-gtk-theme \
        archlinux-logout-gtk4-git \
        kiro-arc-dawn \
        kiro-arc-kde \
        kiro-rofi \
        kiro-rofi-themes \
        kiro-sddm-simplicity \
        kiro-shells \
        kiro-variety-config \
        kiro-xfce \
        flameshot-git \
        gittyup \
        hardcode-fixer-git \
        lastpass \
        neo-candy-icons-git \
        rofi \
        sparklines-git \
        surfn-icons-git \
        wttr

    # Avoid pamac conflict on Manjaro
    if ! grep -q "Manjaro" /etc/os-release; then
        install_packages pamac-aur
    fi
}

# Main execution
log_section "Installing software from nemesis_repo"

ensure_vconsole_font
install_nemesis_software

# Finished
log_subsection "$(script_name) done"