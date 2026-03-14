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

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Remove unused kernels
# - Remove Broadcom and Realtek drivers
# - Remove ArcoLinux Conky packages
##################################################################################################################################

main() {

    log_section "Cleaning system - removing unwanted components"

    ############################################################################################################
    # Remove Broadcom / Realtek drivers
    ############################################################################################################

    log_subsection "Removing Broadcom and Realtek drivers"

    remove_matching_packages_deps \
        broadcom-wl-dkms \
        rtl8821cu-morrownr-dkms-git

    ############################################################################################################
    # Remove extra kernels (keep linux)
    ############################################################################################################

    log_subsection "Removing extra kernels"

    if pacman -Qi linux &>/dev/null && pacman -Qi linux-headers &>/dev/null; then

        remove_matching_packages_deps \
            linux-lts-headers linux-lts \
            linux-zen-headers linux-zen \
            linux-hardened-headers linux-hardened \
            linux-rt-headers linux-rt \
            linux-rt-lts-headers linux-rt-lts \
            linux-cachyos-headers linux-cachyos \
            linux-xanmod-headers linux-xanmod

    else
        log_warn "Cannot proceed: linux kernel or headers not installed"
    fi

    ############################################################################################################
    # Remove conky packages
    ############################################################################################################

    log_subsection "Removing Conky packages"

    remove_matching_packages_deps \
        conky-lua-archers \
        arcolinux-conky-collection-git \
        arcolinux-conky-collection-plasma-git

    log_success "Cleanup completed"
}

main "$@"