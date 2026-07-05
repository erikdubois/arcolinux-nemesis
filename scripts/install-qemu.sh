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
# - Install QEMU/KVM virtualization stack on Arch Linux
# - Install required components: qemu, virt-manager, libvirt, dnsmasq, OVMF, and swtpm
# - Enable and start the libvirtd service
# - Add the current user to the kvm and libvirt groups for non-root VM management
# - Ensure the default libvirt NAT network exists, is started, and autostarts at boot
# - Create an ideal Wayland/niri-capable VM template (virtio-gpu + virgl 3D + blob,
#   memfd shared memory, local SPICE GL, UEFI/q35) ready to clone in virt-manager
# - Provide optional support for enabling nested virtualization (Intel or AMD)
##################################################################################################################################

# Ideal Wayland template settings
TEMPLATE_NAME="kiro-template"
TEMPLATE_DISK="/var/lib/libvirt/images/${TEMPLATE_NAME}.qcow2"
TEMPLATE_DISK_SIZE="40G"

enable_nested_kvm() {
    log_subsection "Enabling nested KVM"

    echo "kvm" | sudo tee /etc/modules-load.d/kvm.conf >/dev/null

    if grep -qi "GenuineIntel" /proc/cpuinfo; then
        append_line_if_missing_root "kvm_intel" /etc/modules-load.d/kvm.conf
        echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf >/dev/null
        sudo modprobe kvm || true
        sudo modprobe kvm_intel || true
    elif grep -qi "AuthenticAMD" /proc/cpuinfo; then
        append_line_if_missing_root "kvm_amd" /etc/modules-load.d/kvm.conf
        echo "options kvm_amd nested=1" | sudo tee /etc/modprobe.d/kvm_amd.conf >/dev/null
        sudo modprobe kvm || true
        sudo modprobe kvm_amd || true
    else
        log_warn "Unknown CPU vendor - skipping nested virtualization"
    fi
}


ensure_default_network() {
    log_subsection "Ensuring default libvirt network"

    if ! sudo virsh net-list --all --name | grep -qx "default"; then
        sudo virsh net-define /usr/share/libvirt/networks/default.xml
    fi

    if ! sudo virsh net-list --name | grep -qx "default"; then
        sudo virsh net-start default
    else
        log_info "Libvirt network default is already active"
    fi

    if ! sudo virsh net-info default | grep -q '^Autostart:.*yes'; then
        sudo virsh net-autostart default
    else
        log_info "Libvirt network default already set to autostart"
    fi
}

ensure_default_pool() {
    log_subsection "Ensuring default libvirt storage pool"

    if sudo virsh -c qemu:///system pool-info default >/dev/null 2>&1; then
        log_info "Storage pool default already exists"
        return 0
    fi

    sudo virsh -c qemu:///system pool-define-as default dir --target /var/lib/libvirt/images
    sudo virsh -c qemu:///system pool-build default
    sudo virsh -c qemu:///system pool-start default
    sudo virsh -c qemu:///system pool-autostart default
}

ensure_wayland_template() {
    log_subsection "Creating ideal Wayland/niri VM template"

    if ! sudo test -f "$TEMPLATE_DISK"; then
        sudo qemu-img create -f qcow2 "$TEMPLATE_DISK" "$TEMPLATE_DISK_SIZE" >/dev/null
        sudo virsh -c qemu:///system pool-refresh default >/dev/null || true
        log_info "Created template disk ${TEMPLATE_DISK} (${TEMPLATE_DISK_SIZE}, sparse)"
    else
        log_info "Template disk already exists: ${TEMPLATE_DISK}"
    fi

    local xml
    xml="$(mktemp)"
    cat >"$xml" <<EOF
<domain type='kvm'>
  <name>${TEMPLATE_NAME}</name>
  <memory unit='GiB'>10</memory>
  <currentMemory unit='GiB'>10</currentMemory>
  <memoryBacking>
    <source type='memfd'/>
    <access mode='shared'/>
  </memoryBacking>
  <vcpu placement='static'>8</vcpu>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <boot dev='hd'/>
    <boot dev='cdrom'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='maximum'>
    <topology sockets='1' cores='4' threads='2'/>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='${TEMPLATE_DISK}'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>
    <controller type='usb' model='qemu-xhci'/>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <console type='pty'/>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
    </channel>
    <input type='tablet' bus='usb'/>
    <graphics type='spice'>
      <listen type='none'/>
      <gl enable='yes'/>
    </graphics>
    <video>
      <model type='virtio' heads='1' primary='yes' blob='on'>
        <acceleration accel3d='yes'/>
      </model>
    </video>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
EOF

    sudo virsh -c qemu:///system define "$xml" >/dev/null
    rm -f "$xml"
    log_info "Defined Wayland template domain: ${TEMPLATE_NAME} (clone it in virt-manager to make a VM)"
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
    add_user_to_group "$USER_NAME" kvm
    add_user_to_group "$USER_NAME" libvirt

    reload_firewalld_for_libvirt
    ensure_default_network
    bind_virbr0_to_libvirt_zone
    ensure_default_pool
    ensure_wayland_template

    # Optional: only enable if you really need nested virtualization
    # enable_nested_kvm

    log_success "QEMU/KVM installation completed"
    log_info "Open virt-manager to create a new VM"
    log_warn "Log out and back in for group membership to apply"
}
main "$@"