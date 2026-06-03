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
# - Install kiro-neo-candy and surfn-plasma-flow icon themes from nemesis_repo
# - Covers 8 themes total (neo-candy variants: arc, arc-mint-grey/red, qogir, tela; papirus-dark-tela variants; surfn-plasma-flow)
# - Iterates one package at a time with numbered progress logging
##################################################################################################################################

install_nemesis_icon_themes() {
    local pkgs=(
        kiro-neo-candy-arc
        kiro-neo-candy-arc-mint-grey
        kiro-neo-candy-arc-mint-red
        kiro-neo-candy-qogir
        kiro-neo-candy-tela
        kiro-papirus-dark-tela
        kiro-papirus-dark-tela-grey
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