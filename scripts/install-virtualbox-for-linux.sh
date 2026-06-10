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
    # Kernel headers — install for every kernel currently on the system
    ############################################################################################################

    log_subsection "Installing kernel headers"
    declare -A kernel_headers=(
        [linux]=linux-headers
        [linux-lts]=linux-lts-headers
        [linux-zen]=linux-zen-headers
        [linux-hardened]=linux-hardened-headers
        [linux-lqx]=linux-lqx-headers
        [linux-cachyos]=linux-cachyos-headers
    )
    for kern in "${!kernel_headers[@]}"; do
        if pkg_installed "$kern"; then
            install_packages "${kernel_headers[$kern]}"
        fi
    done

    ############################################################################################################
    # VirtualBox
    ############################################################################################################

    install_packages \
        virtualbox \
        virtualbox-host-dkms

    ############################################################################################################
    # Kernel modules — load now and persist across reboots
    ############################################################################################################

    log_subsection "Loading VirtualBox kernel modules"
    printf 'vboxdrv\nvboxnetadp\nvboxnetflt\n' | sudo tee /etc/modules-load.d/virtualbox.conf > /dev/null
    sudo modprobe vboxdrv vboxnetadp vboxnetflt

    ############################################################################################################
    # User group
    ############################################################################################################

    if [[ -n "${SUDO_USER:-}" ]]; then
        log_subsection "Adding ${SUDO_USER} to vboxusers group"
        gpasswd -a "$SUDO_USER" vboxusers
    fi

    ############################################################################################################
    # Remove VirtualBox GUI warnings and suppress log files
    ############################################################################################################

    # Suppress all VirtualBox GUI warning/error popups (e.g. "cannot power off cleanly")
    VBoxManage setextradata global GUI/SuppressMessages "all" || true

    # Disable host time sync for the VM named "template" (prevents guest clock from being
    # overwritten by the host, useful when the guest manages its own time via NTP)
    VBoxManage setextradata "template" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" 1

    # Redirect all VM process log output to /dev/null globally
    VBoxManage setextradata global "VBoxInternal/Log/File" "/dev/null" || true

    # Suppress per-VM process logs (VirtualBoxVM/VBoxHeadless write them to CWD)
    append_line_if_missing_root /etc/environment "VBOX_LOG_DEST=nofile"

    # Redirect the VirtualBox GUI log file to /dev/null so it never grows in ~/.config/VirtualBox/
    if [[ -n "${SUDO_USER:-}" ]]; then
        local vbox_cfg_dir="/home/${SUDO_USER}/.config/VirtualBox"
        mkdir -p "$vbox_cfg_dir"
        ln -sf /dev/null "${vbox_cfg_dir}/VirtualBox.log"
        chown -R "${SUDO_USER}:${SUDO_USER}" "$vbox_cfg_dir"
    fi

    log_success "VirtualBox installed"
    log_warn "Reboot recommended"
}

main "$@"