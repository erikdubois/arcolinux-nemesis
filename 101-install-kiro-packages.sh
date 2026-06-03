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
#   shells, variety-config, xfce, powermenu, plymouth-theme-kiro-logo
# - Kiro icon themes: neo-candy variants (arc, arc-mint-grey/red, qogir, tela) and papirus-dark-tela variants
# - kiro-system-files installed separately (dry-run + guarded) since it overwrites /etc and may conflict
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
        plymouth-theme-kiro-logo \
        kiro-neo-candy-arc \
        kiro-neo-candy-arc-mint-grey \
        kiro-neo-candy-arc-mint-red \
        kiro-neo-candy-qogir \
        kiro-neo-candy-tela \
        kiro-papirus-dark-tela \
        kiro-papirus-dark-tela-grey
}

# Install kiro-system-files on its own — it overwrites real /etc system files and
# can hit "exists in filesystem" conflicts. A dry-run confirms it resolves first;
# the real install runs in a condition context so any failure logs a warning and
# the pipeline keeps going instead of aborting the whole batch.
install_kiro_system_files() {
    log_subsection "kiro-system-files: dry-run check"

    if ! sudo pacman -Sp kiro-system-files &>/dev/null; then
        log_warn "kiro-system-files not found in repos - skipping"
        return 0
    fi

    log_info "Dry-run OK - installing kiro-system-files"

    if sudo pacman -S --noconfirm --needed kiro-system-files; then
        log_success "kiro-system-files installed"
    else
        log_warn "kiro-system-files failed to install - continuing pipeline"
    fi
}

# Main execution
log_section "Installing Kiro packages from nemesis_repo"

install_kiro_packages
install_kiro_system_files

# Finished
log_subsection "$(script_name) done"
