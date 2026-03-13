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

remove_surfn_extras() {

    log_section "Removing software from nemesis_repo"

    local packages=(
        surfn-arc-breeze-icons-git
        surfn-mint-y-icons-git
        surfn-plasma-flow-git
        surfn-plasma-dark-icons-git
        surfn-plasma-light-icons-git
        surfn-icons-git
    )

    local count=0
    local pkg

    for pkg in "${packages[@]}"; do
        ((++count))
        log_subsection "Removing package nr. ${count} ${pkg}"
        remove_packages "${pkg}"
    done
}

remove_surfn_extras

log_subsection "$(script_name) done"