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
# - Install all Kiro packages from nemesis_repo, gathered in one place
# - Core Kiro set: dot-files, arc-dawn, arc-kde, keybindings, rofi + rofi-themes, sddm-simplicity,
#   shells, variety-config, xfce, powermenu, system-files, plymouth-theme-kiro-logo
# - Kiro icon themes: neo-candy variants (arc, arc-mint-grey/red, qogir, tela) and papirus-dark-tela variants
##################################################################################################################################

# Load shared helper functions
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

# Log current script
log_section "Running $(script_name)"

# Pause when debug mode is enabled
pause_if_debug

# Install all Kiro packages from nemesis_repo
install_kiro_packages() {
    install_packages \
        kiro-dot-files \
        kiro-arc-dawn \
        kiro-arc-kde \
        kiro-keybindings \
        kiro-rofi \
        kiro-rofi-themes \
        kiro-sddm-simplicity \
        kiro-shells \
        kiro-variety-config \
        kiro-xfce \
        kiro-powermenu \
        kiro-system-files \
        plymouth-theme-kiro-logo \
        kiro-neo-candy-arc \
        kiro-neo-candy-arc-mint-grey \
        kiro-neo-candy-arc-mint-red \
        kiro-neo-candy-qogir \
        kiro-neo-candy-tela \
        kiro-papirus-dark-tela \
        kiro-papirus-dark-tela-grey
}

# Main execution
log_section "Installing Kiro packages from nemesis_repo"

install_kiro_packages

# Finished
log_subsection "$(script_name) done"
