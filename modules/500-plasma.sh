#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"
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
#   Purpose:
#   - Install extra Plasma-only packages.
#   - Skip cleanly when Plasma is not already present.
#
##################################################################################################################################

install_plasma_extras() {
    # This script augments an existing Plasma install. It does not pull in
    # the full Plasma desktop on its own.
    if [[ ! -f /usr/share/wayland-sessions/plasma.desktop ]]; then
        log_warn "Plasma is not installed - skipping Plasma extras"
        return 0
    fi

    log_section "Plasma detected - extra software to install"

    install_packages edu-plasma-keybindings-git edu-plasma-servicemenus-git obs-studio \
        surfn-plasma-dark-icons-git surfn-plasma-light-icons-git
}

install_plasma_extras

log_subsection "$(script_name) done"
