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

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install VMware Workstation
# - Install linux headers if needed
# - Enable VMware networking service
##################################################################################################################################

main() {

    log_section "Installing VMware Workstation"

    ############################################################################################################
    # Kernel headers
    ############################################################################################################

    if pkg_installed linux; then
        install_packages linux-headers
    fi

    ############################################################################################################
    # VMware Workstation (AUR)
    ############################################################################################################

    if pkg_installed vmware-workstation; then
        log_info "vmware-workstation already installed"
    else
        log_subsection "Installing vmware-workstation (AUR)"
        yay -S --noconfirm vmware-workstation
    fi

    ############################################################################################################
    # VMware networking
    ############################################################################################################

    enable_now_service vmware-networks.service

    log_success "VMware Workstation installed"
    log_warn "Reboot recommended"
}

main "$@"