#!/bin/bash
set -euo pipefail
echo
green=$(printf '\033[32m')
reset=$(printf '\033[0m')

cat << EOF
${green}=====================================
    ██╗  ██╗██╗██████╗  ██████╗ 
    ██║ ██╔╝██║██╔══██╗██╔═══██╗
    █████╔╝ ██║██████╔╝██║   ██║
    ██╔═██╗ ██║██╔══██╗██║   ██║
    ██║  ██╗██║██║  ██║╚██████╔╝
    ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ 
         TESTED ON K I R O
=====================================${reset}
EOF
echo
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

# -----------------------------
# Config
# -----------------------------
USER_NAME="${SUDO_USER:-$(whoami)}"

PACKAGES=(
  qemu-full
  virt-manager
  libvirt
  dnsmasq
  iptables
  edk2-ovmf
  swtpm
)

# -----------------------------
# Helpers
# -----------------------------

# Ensure a line exists in a file (no duplicates)
ensure_line() {
  local file="$1"
  local line="$2"

  sudo touch "$file"
  # -q  quiet, -x match whole line, -F fixed string
  if ! sudo grep -qxF "$line" "$file" 2>/dev/null; then
    echo "  + $line -> $file"
    echo "$line" | sudo tee -a "$file" >/dev/null
  else
    echo "  = $line already in $file"
  fi
}

# Section header
section() {
  echo
  echo "==> $*"
}

# -----------------------------
# 1. CPU check
# -----------------------------
section "Checking CPU virtualization support (Intel VT-x)"

if grep -q "vmx" /proc/cpuinfo; then
  echo "  ✓ VT-x (vmx) flag found."
else
  echo "  ✗ No vmx flag detected!"
  echo "    -> Enable Intel VT-x in BIOS/UEFI (and VT-d for passthrough)."
  echo "    -> Continuing anyway, but KVM acceleration may not work."
fi

# -----------------------------
# 2. Install packages
# -----------------------------
section "Installing packages (Arch)"

echo "  Packages: ${PACKAGES[*]}"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# -----------------------------
# 3. KVM modules + nested virtualization
# -----------------------------
section "Configuring KVM modules (kvm, kvm_intel)"

# Modules loaded at boot
ensure_line "/etc/modules-load.d/kvm.conf" "kvm"
ensure_line "/etc/modules-load.d/kvm.conf" "kvm_intel"

echo "  Loading modules now..."
sudo modprobe kvm || true
sudo modprobe kvm_intel || true

# Nested KVM
section "Enabling nested virtualization for kvm_intel"

ensure_line "/etc/modprobe.d/kvm_intel.conf" "options kvm_intel nested=1"

# Try to reload module so nested=1 takes effect immediately
if lsmod | grep -q "^kvm_intel"; then
  echo "  Reloading kvm_intel to apply nested=1..."
  sudo modprobe -r kvm_intel kvm || true
  sudo modprobe kvm
  sudo modprobe kvm_intel
else
  echo "  kvm_intel not currently loaded; nested=1 will be active after next load/reboot."
fi

if [[ -f /sys/module/kvm_intel/parameters/nested ]]; then
  echo -n "  Current nested setting: "
  cat /sys/module/kvm_intel/parameters/nested
else
  echo "  /sys/module/kvm_intel/parameters/nested not found (module may not be loaded yet)."
fi

# -----------------------------
# 4. libvirt service + groups
# -----------------------------
section "Enabling libvirtd and adding user to groups"

echo "  Enabling + starting libvirtd.service..."
sudo systemctl enable --now libvirtd.service

echo "  Adding $USER_NAME to kvm and libvirt groups (if not already)..."
sudo gpasswd -a "$USER_NAME" kvm    || true
sudo gpasswd -a "$USER_NAME" libvirt || true

echo "  (You must log out and back in for new group memberships to apply.)"

# -----------------------------
# 5. libvirt default network
# -----------------------------
section "Configuring libvirt default NAT network"

# Check if 'default' network exists
if sudo virsh net-list --all --name | grep -qx "default"; then
  echo "  = 'default' network already defined."
else
  echo "  + Defining 'default' NAT network..."
  TMP_NET_XML="$(mktemp)"

  cat >"$TMP_NET_XML" <<'EOF'
<network>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
EOF

  sudo virsh net-define "$TMP_NET_XML"
  rm -f "$TMP_NET_XML"
fi

# Start the network if it is not active
if sudo virsh net-list --name | grep -qx "default"; then
  echo "  = 'default' network already active."
else
  echo "  + Starting 'default' network..."
  sudo virsh net-start default
fi

# Ensure network autostarts on boot
echo "  + Enabling autostart for 'default' network..."
sudo virsh net-autostart default

echo
echo "  Current libvirt networks:"
sudo virsh net-list --all || true

# -----------------------------
# 6. Basic checks
# -----------------------------
section "Sanity checks"

echo -n "  /dev/kvm: "
if [[ -e /dev/kvm ]]; then
  echo "exists"
  ls -l /dev/kvm || true
else
  echo "NOT present – check BIOS VT-x and modules."
fi

echo
echo "  Loaded KVM modules:"
lsmod | grep -E 'kvm(_intel)?' || echo "  No kvm modules loaded."

echo
echo "  libvirtd status (short):"
systemctl --no-pager --full status libvirtd.service | sed -n '1,5p' || true

# -----------------------------
# 7. Final hints
# -----------------------------
section "Done"

cat <<EOF
Next steps:

  1) Log out and log back in, so group changes (kvm, libvirt) take effect.
  2) Start 'virt-manager' and connect to:
       QEMU/KVM - QEMU system (qemu:///system)
  3) In new VMs:
       - Firmware: OVMF (UEFI)
       - Chipset: Q35
       - CPU:   host-passthrough
       - Disk:  virtio
       - NIC:   virtio (using 'default' NAT network)

EOF