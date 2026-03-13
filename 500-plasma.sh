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

install_plasma_extras() {

    if [[ ! -f /usr/share/wayland-sessions/plasma.desktop && \
      ! -f /usr/share/xsessions/plasma.desktop ]]; then
        log_warn "Plasma is not installed - skipping Plasma extras"
        return 0
    fi

    log_section "Plasma detected"
    echo "This will not install Plasma"
    echo "It detects whether Plasma is installed like when on ArcoPlasma"
    echo

    log_section "Plasma software to install"

    install_packages \
        edu-plasma-keybindings-git \
        edu-plasma-servicemenus-git \
        obs-studio \
        surfn-plasma-dark-icons-git \
        surfn-plasma-light-icons-git
}

install_plasma_extras

log_subsection "$(script_name) done"