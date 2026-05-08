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

    # Suppress all VirtualBox GUI warning/error popups (e.g. "cannot power off cleanly")
    VBoxManage setextradata global GUI/SuppressMessages "all" || true

    # Disable host time sync for the VM named "template" (prevents guest clock from being
    # overwritten by the host, useful when the guest manages its own time via NTP)
    VBoxManage setextradata "template" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" 1

    # Redirect all VM log output to /dev/null globally (disables log file creation for all VMs)
    VBoxManage setextradata global "VBoxInternal/Log/File" "/dev/null" || true
    log_success "VirtualBox installed"
    log_warn "Reboot recommended"
}

main "$@"