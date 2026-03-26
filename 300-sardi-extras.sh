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

install_sardi_extras() {

    log_section "Installing software from nemesis_repo"

    local packages=(
        sardi-icons
        sardi-colora-variations-icons-git
        sardi-flat-colora-variations-icons-git
        sardi-flat-mint-y-icons-git
        sardi-flat-mixing-icons-git
        sardi-flexible-colora-variations-icons-git
        sardi-flexible-luv-colora-variations-icons-git
        sardi-flexible-mint-y-icons-git
        sardi-flexible-mixing-icons-git
        sardi-flexible-variations-icons-git
        sardi-ghost-flexible-colora-variations-icons-git
        sardi-ghost-flexible-mint-y-icons-git
        sardi-ghost-flexible-mixing-icons-git
        sardi-ghost-flexible-variations-icons-git
        sardi-mint-y-icons-git
        sardi-mixing-icons-git
        sardi-mono-colora-variations-icons-git
        sardi-mono-mint-y-icons-git
        sardi-mono-mixing-icons-git
        sardi-mono-numix-colora-variations-icons-git
        sardi-mono-papirus-colora-variations-icons-git
        sardi-orb-colora-mint-y-icons-git
        sardi-orb-colora-mixing-icons-git
        sardi-orb-colora-variations-icons-git
    )

    local count=0
    local pkg

    for pkg in "${packages[@]}"; do
        ((++count))
        log_subsection "Installing package nr. ${count} ${pkg}"
        install_packages "${pkg}"
    done
}

install_sardi_extras

log_subsection "$(script_name) done"