#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

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
#
# Purpose
# - Install both virtualization stacks by default so users can run VMs out of the box:
#   - QEMU/KVM + virt-manager, defining the kiro-template VM (install-qemu.sh)
#   - VirtualBox + host modules (install-virtualbox-for-linux.sh)
# - The VirtualBox template VM is copied into ~/VirtualBox VMs/ on real hardware by 930-real-metal.sh.
#
##################################################################################################################################

install_qemu() {
    bash "${SCRIPT_DIR}/install-qemu.sh"
}

install_virtualbox() {
    bash "${SCRIPT_DIR}/install-virtualbox-for-linux.sh"
}

install_qemu
install_virtualbox

log_subsection "$(script_name) done"
