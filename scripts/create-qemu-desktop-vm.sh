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

set -Eeuo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Create a new QEMU/KVM (libvirt) VM sized and configured for ONE desktop we ship (X11 or Wayland)
# - Takes 1/3 of the host CPU threads and 1/3 of the host RAM
# - Numbered menu; pick_desktop() holds one case branch per desktop with its video profile - edit it there
# - Based on personal/settings/qemu-template/kiro-template.xml (UEFI, q35, virtio disk/net, SPICE)
# - Never overwrites an existing VM or disk; leaves kiro-template alone
#
# Usage
#   create-qemu-desktop-vm.sh [desktop] [--iso PATH] [--name NAME] [--disk-size 60G] [--profile P] [--dry-run]
#   No desktop given -> menu.  --dry-run writes the XML and validates it, defines nothing.
#
# Video profiles (why they exist - see Kiro-HQ Kirotux/WAYLAND-VM-SETUP.md and Kirotux/qemu/)
#   gl       virtio-gpu + virgl 3D + SPICE local GL, no blob. Gives the guest /dev/dri/renderD128.
#            Proven for niri-dms, niri-noctalia, hyprland-dms, hyprland-noctalia, wayfire. Fine for X11.
#   gl-blob  gl + blob='on' + memfd shared memory (the kiro-template setup). Only if you need blob resources.
#   nogl     plain virtio-vga, SPICE GL off -> guest renders in software (llvmpipe).
#            hyprland-impasto froze on a black screen with blob + virtio-vga-gl; this is its working setup.
##################################################################################################################################

CONNECT="qemu:///system"
POOL="default"
DISK_SIZE="60G"
DESKTOP=""
VM_NAME=""
ISO=""
PROFILE=""
PROFILE_OVERRIDE=""
DRY_RUN=false
NOTE=""
CHOICE=""

HYPR_NOTE="Hyprland in a VM: invisible cursor or black screen -> WLR_NO_HARDWARE_CURSORS=1 + WLR_RENDERER_ALLOW_SOFTWARE=1. QEMU picks display scale 1.5 - set 100%."
WLR_NOTE="wlroots: invisible cursor -> WLR_NO_HARDWARE_CURSORS=1. Not yet verified in QEMU."
X11_NOTE="X11: install spice-vdagent in the guest for auto-resize and clipboard."

show_menu() {
    cat <<'EOF'
  X11                         X11 + Wayland        Wayland
   1) awesome                 12) plasma           14) niri              22) wayfire
   2) bspwm                   13) gnome            15) niri-dms          23) sway
   3) budgie                                       16) niri-noctalia     24) river
   4) chadwm                                       17) hyprland          25) labwc
   5) cinnamon                                     18) hyprland-dms      26) dwl
   6) i3                                           19) hyprland-noctalia 27) mango
   7) leftwm                                       20) hyprland-noctura  28) scroll
   8) mate                                         21) hyprland-impasto
   9) ohmychadwm
  10) qtile
  11) xfce
EOF
}

usage() {
    sed -n '/^# Usage/,/^#   No desktop/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,3\}//'
    echo "Desktop: a number or a name from this list"
    show_menu
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --iso)       ISO="$2"; shift 2 ;;
            --name)      VM_NAME="$2"; shift 2 ;;
            --disk-size) DISK_SIZE="$2"; shift 2 ;;
            --profile)   PROFILE_OVERRIDE="$2"; shift 2 ;;
            --dry-run)   DRY_RUN=true; shift ;;
            -h|--help)   usage; exit 0 ;;
            -*)          log_error "Unknown option: $1"; usage; exit 1 ;;
            *)           CHOICE="$1"; shift ;;
        esac
    done
}

##################################################################################################################################
# Per-desktop case - one branch per desktop. Change PROFILE here when a desktop misbehaves in QEMU.
#   PROFILE: gl | gl-blob | nogl  (see Purpose at the top)
##################################################################################################################################

pick_desktop() {
    if [[ -z "$CHOICE" ]]; then
        log_subsection "Which desktop will this VM run?"
        show_menu
        read -rp "Number or name: " CHOICE
    fi

    case "$CHOICE" in
        # ── X11 ──────────────────────────────────────────────────────────────
        1|awesome)            DESKTOP="awesome";            PROFILE="gl";   NOTE="$X11_NOTE" ;;
        2|bspwm)              DESKTOP="bspwm";              PROFILE="gl";   NOTE="$X11_NOTE" ;;
        3|budgie)             DESKTOP="budgie";             PROFILE="gl";   NOTE="$X11_NOTE" ;;
        4|chadwm)             DESKTOP="chadwm";             PROFILE="gl";   NOTE="$X11_NOTE" ;;
        5|cinnamon)           DESKTOP="cinnamon";           PROFILE="gl";   NOTE="$X11_NOTE" ;;
        6|i3)                 DESKTOP="i3";                 PROFILE="gl";   NOTE="$X11_NOTE" ;;
        7|leftwm)             DESKTOP="leftwm";             PROFILE="gl";   NOTE="$X11_NOTE" ;;
        8|mate)               DESKTOP="mate";               PROFILE="gl";   NOTE="$X11_NOTE" ;;
        9|ohmychadwm)         DESKTOP="ohmychadwm";         PROFILE="gl";   NOTE="$X11_NOTE" ;;
        10|qtile)             DESKTOP="qtile";              PROFILE="gl";   NOTE="$X11_NOTE" ;;
        11|xfce)              DESKTOP="xfce";               PROFILE="gl";   NOTE="$X11_NOTE" ;;

        # ── X11 + Wayland ────────────────────────────────────────────────────
        12|plasma)            DESKTOP="plasma";             PROFILE="gl";   NOTE="Pick the Wayland or X11 session at the login screen; both run on virgl." ;;
        13|gnome)             DESKTOP="gnome";              PROFILE="gl";   NOTE="Pick the Wayland or X11 session at the login screen; both run on virgl." ;;

        # ── Wayland ──────────────────────────────────────────────────────────
        14|niri)              DESKTOP="niri";               PROFILE="gl";   NOTE="Check in the guest: ls /dev/dri -> renderD128 must be there." ;;
        15|niri-dms)          DESKTOP="niri-dms";           PROFILE="gl";   NOTE="Proven on virtio-vga-gl (2026-10-11)." ;;
        16|niri-noctalia)     DESKTOP="niri-noctalia";      PROFILE="gl";   NOTE="Proven on virtio-vga-gl (2026-10-16)." ;;
        17|hyprland)          DESKTOP="hyprland";           PROFILE="gl";   NOTE="$HYPR_NOTE" ;;
        18|hyprland-dms)      DESKTOP="hyprland-dms";       PROFILE="gl";   NOTE="Proven on virtio-vga-gl (2026-10-08). $HYPR_NOTE" ;;
        19|hyprland-noctalia) DESKTOP="hyprland-noctalia";  PROFILE="gl";   NOTE="Proven on virtio-vga-gl (2026-10-16). $HYPR_NOTE" ;;
        20|hyprland-noctura)  DESKTOP="hyprland-noctura";   PROFILE="gl";   NOTE="$HYPR_NOTE" ;;
        21|hyprland-impasto)  DESKTOP="hyprland-impasto";   PROFILE="nogl"; NOTE="blob + virtio-vga-gl froze the screen black (2026-11-03). Software rendering. Set the display scale to 100%." ;;
        22|wayfire)           DESKTOP="wayfire";            PROFILE="gl";   NOTE="Proven on virtio-vga-gl (2026-10-22)." ;;
        23|sway)              DESKTOP="sway";               PROFILE="gl";   NOTE="$WLR_NOTE" ;;
        24|river)             DESKTOP="river";              PROFILE="gl";   NOTE="$WLR_NOTE" ;;
        25|labwc)             DESKTOP="labwc";              PROFILE="gl";   NOTE="$WLR_NOTE" ;;
        26|dwl)               DESKTOP="dwl";                PROFILE="gl";   NOTE="$WLR_NOTE" ;;
        27|mango)             DESKTOP="mango";              PROFILE="gl";   NOTE="$WLR_NOTE" ;;
        28|scroll)            DESKTOP="scroll";             PROFILE="gl";   NOTE="$WLR_NOTE" ;;

        *)
            log_error "Unknown desktop: ${CHOICE}"
            usage
            exit 1
            ;;
    esac

    if [[ -n "$PROFILE_OVERRIDE" ]]; then
        PROFILE="$PROFILE_OVERRIDE"
        NOTE="${NOTE} (profile overridden on the command line)"
    fi

    case "$PROFILE" in
        gl|gl-blob|nogl) ;;
        *) log_error "Unknown profile: ${PROFILE} (gl, gl-blob, nogl)"; exit 1 ;;
    esac
}

##################################################################################################################################
# Checks and sizing
##################################################################################################################################

preflight() {
    log_subsection "Preflight"

    [[ -e /dev/kvm ]] || { log_error "/dev/kvm not found - enable virtualization (VT-x/AMD-V) in the firmware"; exit 1; }

    if [[ "$PROFILE" != "nogl" && ! -e /dev/dri/renderD128 ]]; then
        log_warn "No /dev/dri/renderD128 on the host - SPICE GL will not start. Use --profile nogl."
    fi

    if [[ "$DRY_RUN" == false ]]; then
        if virsh -c "$CONNECT" dominfo "$VM_NAME" >/dev/null 2>&1; then
            log_error "VM '${VM_NAME}' already exists - pick another --name or delete it in virt-manager"
            exit 1
        fi
        if virsh -c "$CONNECT" vol-info --pool "$POOL" "${VM_NAME}.qcow2" >/dev/null 2>&1; then
            log_error "Disk ${VM_NAME}.qcow2 already exists in pool '${POOL}' - will not overwrite it"
            exit 1
        fi
    fi

    if [[ -n "$ISO" ]]; then
        [[ -f "$ISO" ]] || { log_error "ISO not found: ${ISO}"; exit 1; }
        ISO="$(realpath -- "$ISO")"
        if [[ "$ISO" == /home/* ]]; then
            log_warn "ISO is under /home - the qemu user may not be able to read it. If the VM will not start:"
            log_warn "setfacl -m u:libvirt-qemu:x \"\$HOME\"   (or move the ISO to /var/lib/libvirt/images)"
        fi
    fi
}

compute_resources() {
    local threads mem_kib
    threads="$(nproc)"
    VCPUS=$(( threads / 3 ))
    (( VCPUS < 2 )) && VCPUS=2

    mem_kib="$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)"
    MEM_MIB=$(( mem_kib / 1024 / 3 ))
    (( MEM_MIB < 4096 )) && MEM_MIB=4096

    log_info "Host: ${threads} threads, $(( mem_kib / 1024 / 1024 )) GiB RAM -> VM: ${VCPUS} vCPU, $(( MEM_MIB / 1024 )) GiB"
}

##################################################################################################################################
# XML
##################################################################################################################################

write_xml() {
    local out="$1" disk_path="$2"
    local memory_backing="" graphics video boot cdrom_source=""

    case "$PROFILE" in
        gl)
            graphics="<graphics type='spice'>
      <listen type='none'/>
      <gl enable='yes'/>
    </graphics>"
            video="<model type='virtio' heads='1' primary='yes'>
        <acceleration accel3d='yes'/>
      </model>"
            ;;
        gl-blob)
            memory_backing="<memoryBacking>
    <source type='memfd'/>
    <access mode='shared'/>
  </memoryBacking>"
            graphics="<graphics type='spice'>
      <listen type='none'/>
      <gl enable='yes'/>
    </graphics>"
            video="<model type='virtio' heads='1' primary='yes' blob='on'>
        <acceleration accel3d='yes'/>
      </model>"
            ;;
        nogl)
            graphics="<graphics type='spice'>
      <listen type='none'/>
      <gl enable='no'/>
    </graphics>"
            video="<model type='virtio' heads='1' primary='yes'/>"
            ;;
    esac

    if [[ -n "$ISO" ]]; then
        boot="<boot dev='cdrom'/>
    <boot dev='hd'/>"
        cdrom_source="<source file='${ISO}'/>"
    else
        boot="<boot dev='hd'/>
    <boot dev='cdrom'/>"
    fi

    cat >"$out" <<EOF
<domain type='kvm'>
  <name>${VM_NAME}</name>
  <description>Kiro test VM for ${DESKTOP} (profile ${PROFILE}) - create-qemu-desktop-vm.sh</description>
  <memory unit='MiB'>${MEM_MIB}</memory>
  <currentMemory unit='MiB'>${MEM_MIB}</currentMemory>
  ${memory_backing}
  <vcpu placement='static'>${VCPUS}</vcpu>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <firmware>
      <feature enabled='no' name='secure-boot'/>
      <feature enabled='no' name='enrolled-keys'/>
    </firmware>
    ${boot}
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='host-passthrough' check='none' migratable='on'>
    <topology sockets='1' dies='1' cores='${VCPUS}' threads='1'/>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
      <source file='${disk_path}'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      ${cdrom_source}
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>
    <controller type='usb' model='qemu-xhci' ports='15'/>
    <interface type='network'>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
    <console type='pty'/>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
    </channel>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
    </channel>
    <input type='tablet' bus='usb'/>
    <input type='keyboard' bus='usb'/>
    ${graphics}
    <sound model='ich9'>
      <audio id='1'/>
    </sound>
    <audio id='1' type='spice'/>
    <video>
      ${video}
    </video>
    <redirdev bus='usb' type='spicevmc'/>
    <redirdev bus='usb' type='spicevmc'/>
    <memballoon model='virtio'/>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
    </rng>
  </devices>
</domain>
EOF
}

##################################################################################################################################
# Main
##################################################################################################################################

main() {
    parse_args "$@"

    log_section "Creating a QEMU/KVM desktop VM"

    pick_desktop
    VM_NAME="${VM_NAME:-kiro-${DESKTOP}}"
    preflight
    compute_resources

    log_info "Desktop: ${DESKTOP}  VM: ${VM_NAME}  profile: ${PROFILE}  disk: ${DISK_SIZE}"
    log_info "${NOTE}"

    local xml
    if [[ "$DRY_RUN" == true ]]; then
        xml="${TMPDIR:-/tmp}/${VM_NAME}.xml"
        write_xml "$xml" "/var/lib/libvirt/images/${VM_NAME}.qcow2"
        if command -v virt-xml-validate >/dev/null; then
            virt-xml-validate "$xml" domain
        fi
        log_success "Dry run - XML written to ${xml}, nothing defined"
        return 0
    fi

    log_subsection "Creating disk ${VM_NAME}.qcow2 (${DISK_SIZE}, sparse)"
    virsh -c "$CONNECT" vol-create-as "$POOL" "${VM_NAME}.qcow2" "$DISK_SIZE" --format qcow2 >/dev/null
    local disk_path
    disk_path="$(virsh -c "$CONNECT" vol-path --pool "$POOL" "${VM_NAME}.qcow2")"

    log_subsection "Defining VM ${VM_NAME}"
    xml="$(mktemp --suffix=.xml)"
    write_xml "$xml" "$disk_path"
    if ! virsh -c "$CONNECT" define "$xml" >/dev/null; then
        log_error "virsh define failed - XML kept at ${xml}; disk ${disk_path} left in place"
        exit 1
    fi
    rm -f "$xml"

    log_success "VM ${VM_NAME} defined (${VCPUS} vCPU, $(( MEM_MIB / 1024 )) GiB, ${PROFILE})"
    log_info "Start it: virsh -c ${CONNECT} start ${VM_NAME} && virt-manager --connect ${CONNECT} --show-domain-console ${VM_NAME}"
    log_info "In the guest: install spice-vdagent + qemu-guest-agent (systemctl enable --now qemu-guest-agent)"
}

main "$@"
