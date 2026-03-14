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
# - Install QEMU/KVM virtualization
# - Enable libvirt service
# - Enable nested virtualization
# - Create default NAT network
##################################################################################################################################

main() {

    local USER_NAME="${SUDO_USER:-$(whoami)}"

    log_section "Installing QEMU/KVM virtualization"

    ############################################################################################################
    # Install packages
    ############################################################################################################

    install_packages \
        qemu-full \
        virt-manager \
        libvirt \
        dnsmasq \
        iptables \
        edk2-ovmf \
        swtpm

    ############################################################################################################
    # Enable libvirt
    ############################################################################################################

    enable_now_service libvirtd.service

    log_subsection "Adding user to virtualization groups"
    sudo gpasswd -a "$USER_NAME" kvm || true
    sudo gpasswd -a "$USER_NAME" libvirt || true

    ############################################################################################################
    # Enable nested virtualization
    ############################################################################################################

    log_subsection "Enabling nested KVM"

    echo "kvm" | sudo tee /etc/modules-load.d/kvm.conf >/dev/null
    echo "kvm_intel" | sudo tee -a /etc/modules-load.d/kvm.conf >/dev/null

    echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf >/dev/null

    sudo modprobe kvm || true
    sudo modprobe kvm_intel || true

    ############################################################################################################
    # Configure libvirt default network
    ############################################################################################################

    log_subsection "Ensuring default libvirt network"

    if ! sudo virsh net-list --all --name | grep -qx "default"; then
        sudo virsh net-define /usr/share/libvirt/networks/default.xml
    fi

    sudo virsh net-start default || true
    sudo virsh net-autostart default

    ############################################################################################################

    log_success "QEMU/KVM installation completed"
    log_warn "Log out and back in for group membership to apply"
}

main "$@"