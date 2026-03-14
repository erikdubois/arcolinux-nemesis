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

enable_nested_kvm() {
    log_subsection "Enabling nested KVM"

    echo "kvm" | sudo tee /etc/modules-load.d/kvm.conf >/dev/null

    if grep -qi "GenuineIntel" /proc/cpuinfo; then
        append_if_missing "kvm_intel" /etc/modules-load.d/kvm.conf
        echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf >/dev/null
        sudo modprobe kvm || true
        sudo modprobe kvm_intel || true
    elif grep -qi "AuthenticAMD" /proc/cpuinfo; then
        append_if_missing "kvm_amd" /etc/modules-load.d/kvm.conf
        echo "options kvm_amd nested=1" | sudo tee /etc/modprobe.d/kvm_amd.conf >/dev/null
        sudo modprobe kvm || true
        sudo modprobe kvm_amd || true
    else
        log_warn "Unknown CPU vendor - skipping nested virtualization"
    fi
}

append_if_missing() {
    local line="$1"
    local file="$2"

    if [[ ! -f "$file" ]]; then
        echo "$line" | sudo tee "$file" >/dev/null
        return
    fi

    if ! grep -Fqx "$line" "$file"; then
        echo "$line" | sudo tee -a "$file" >/dev/null
    fi
}

ensure_default_network() {
    log_subsection "Ensuring default libvirt network"

    if ! sudo virsh net-list --all --name | grep -qx "default"; then
        sudo virsh net-define /usr/share/libvirt/networks/default.xml
    fi

    if ! sudo virsh net-info default | grep -q '^Active:.*yes'; then
        sudo virsh net-start default
    fi

    sudo virsh net-autostart default
}

main() {
    local USER_NAME="${SUDO_USER:-$(whoami)}"

    log_section "Installing QEMU/KVM virtualization"

    install_packages \
        qemu-desktop \
        virt-manager \
        libvirt \
        dnsmasq \
        edk2-ovmf \
        swtpm

    enable_now_service libvirtd.service

    log_subsection "Adding user to virtualization groups"
    sudo gpasswd -a "$USER_NAME" kvm || true
    sudo gpasswd -a "$USER_NAME" libvirt || true

    ensure_default_network

    # Optional: only enable if you really need nested virtualization
    # enable_nested_kvm

    log_success "QEMU/KVM installation completed"
    log_warn "Log out and back in for group membership to apply"
}
main "$@"