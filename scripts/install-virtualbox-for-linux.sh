#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install VirtualBox virtualization
# - Install kernel headers when linux kernel is used
##################################################################################################################################

main() {

    log_section "Installing VirtualBox"

    ############################################################################################################
    # Kernel headers
    ############################################################################################################

    if pkg_installed linux; then
        log_subsection "Installing linux headers"
        install_packages linux-headers
    fi

    ############################################################################################################
    # VirtualBox
    ############################################################################################################

    install_packages \
        virtualbox \
        virtualbox-host-dkms

    ############################################################################################################
    # Remove VirtualBox GUI warnings
    ############################################################################################################

    VBoxManage setextradata global GUI/SuppressMessages "all" || true

    log_success "VirtualBox installed"
    log_warn "Reboot recommended"
}

main "$@"