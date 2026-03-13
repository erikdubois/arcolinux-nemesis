#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

install_nemesis_icon_themes() {
    local pkgs=(
        edu-neo-candy-arc-git
        edu-neo-candy-arc-mint-grey-git
        edu-neo-candy-arc-mint-red-git
        edu-neo-candy-qogir-git
        edu-neo-candy-tela-git
        edu-papirus-dark-tela-git
        edu-papirus-dark-tela-grey-git
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