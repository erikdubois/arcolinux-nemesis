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

install_surfn_extras() {

    log_section "Installing software from nemesis_repo"

    local packages=(
        surfn-icons-git
        surfn-arc-breeze-icons-git
        surfn-mint-y-icons-git
        surfn-plasma-dark-icons-git
        surfn-plasma-light-icons-git
        surfn-plasma-flow-git
    )

    local count=0
    local pkg

    for pkg in "${packages[@]}"; do
        ((++count))
        log_subsection "Installing package nr. ${count} ${pkg}"
        install_packages "${pkg}"
    done
}

install_surfn_extras

log_subsection "$(script_name) done"