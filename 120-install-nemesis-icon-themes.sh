#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

pause_if_debug

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
# - Install the surfn-plasma-flow icon theme from nemesis_repo
# - Iterates one package at a time with numbered progress logging
# - Kiro icon themes (neo-candy, papirus-dark-tela) now live in 101-install-kiro-packages.sh
##################################################################################################################################

install_nemesis_icon_themes() {
    local pkgs=(
        surfn-plasma-flow-git
    )

    log_section "Install all icons from Nemesis repo"

    local count=0
    local pkg

    for pkg in "${pkgs[@]}"; do
        ((++count))
        log_subsection "Installing package nr. ${count} ${pkg}"
        install_packages "${pkg}"
    done
}

log_warn "Edu icon themes"

install_nemesis_icon_themes

log_subsection "$(script_name) done"