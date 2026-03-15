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
        archlinux-tweak-tool-git \
        edu-dot-files-git \
        arc-gtk-theme \
        archlinux-logout-git \
        edu-arc-dawn-git \
        edu-arc-kde \
        edu-hblock-git \
        edu-rofi-git \
        edu-rofi-themes-git \
        edu-sddm-simplicity-git \
        edu-shells-git \
        edu-variety-config-git \
        edu-xfce-git \
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

install_xfce_extras_if_needed
ensure_vconsole_font
install_nemesis_software

# Finished
log_subsection "$(script_name) done"