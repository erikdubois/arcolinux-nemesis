#!/bin/sh

# Portable version of 930-real-metal.sh
# Runs from Bash or Fish because the script itself is executed by /bin/sh.
# Execute it, do not source it from Fish.

# Resolve script path without BASH_SOURCE.
SCRIPT_PATH=$0
case "$SCRIPT_PATH" in
    /*) : ;;
    *) SCRIPT_PATH=$(command -v -- "$SCRIPT_PATH" 2>/dev/null || printf '%s' "$SCRIPT_PATH") ;;
esac

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)
PARENT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
COMMON_SH="$PARENT_DIR/common/common.sh"

if [ ! -f "$COMMON_SH" ]; then
    printf 'Error: common file not found: %s\n' "$COMMON_SH" >&2
    exit 1
fi

# shellcheck disable=SC1090
. "$COMMON_SH"

log_section "Running $(script_name)"

SETTINGS_DIR="$SCRIPT_DIR/settings"

pause_if_debug

##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
# Github    : https://github.com/buildra
# SF        : https://sourceforge.net/projects/kiro/files/
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

get_virtualization_type_portable() {
    result=""
    vendor=""
    product=""
    combined=""

    if command -v systemd-detect-virt >/dev/null 2>&1; then
        if systemd-detect-virt --quiet >/dev/null 2>&1; then
            result=$(systemd-detect-virt 2>/dev/null)
            if [ -n "$result" ]; then
                printf '%s\n' "$result"
                return 0
            fi
        fi
    fi

    vendor=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)
    product=$(cat /sys/class/dmi/id/product_name 2>/dev/null)
    combined="$vendor $product"

    case "$combined" in
        *VirtualBox*) printf '%s\n' "oracle" ;;
        *VMware*)     printf '%s\n' "vmware" ;;
        *KVM*)        printf '%s\n' "kvm" ;;
        *QEMU*)       printf '%s\n' "qemu" ;;
        *Microsoft*)  printf '%s\n' "microsoft" ;;
        *)
            if grep -qi hypervisor /proc/cpuinfo 2>/dev/null; then
                printf '%s\n' "unknown-vm"
            else
                printf '%s\n' "none"
            fi
            ;;
    esac
}

handle_virtualbox_template() {
    result=$(get_virtualization_type_portable)
    template_dir="$SETTINGS_DIR/virtualbox-template"
    vm_dir="$HOME/VirtualBox VMs"

    log_section "Virtualization detection"
    printf 'Result: %s\n\n' "$result"

    if [ "$result" = "none" ]; then
        log_section "Real hardware detected - installing VirtualBox template"

        if [ ! -d "$template_dir" ]; then
            log_warn "Template directory not found: $template_dir"
            return 1
        fi

        mkdir -p "$vm_dir" || {
            log_warn "Failed to create directory: $vm_dir"
            return 1
        }

        cp -rf "$template_dir/." "$vm_dir/" || {
            log_warn "Failed to copy VirtualBox template files"
            return 1
        }

        cd "$vm_dir" || {
            log_warn "Failed to enter directory: $vm_dir"
            return 1
        }

        if [ -f "$vm_dir/template.tar.gz" ]; then
            tar -xzf "$vm_dir/template.tar.gz" || {
                log_warn "Failed to extract template.tar.gz"
                return 1
            }
            rm -f "$vm_dir/template.tar.gz" || {
                log_warn "Failed to remove template.tar.gz"
                return 1
            }
        else
            log_warn "template.tar.gz not found in $vm_dir"
        fi
    else
        log_warn "Virtual machine detected - skipping VirtualBox template"
        log_warn "Template not copied over"
        log_warn "We will set your screen resolution with xrandr"

        if ! command -v xrandr >/dev/null 2>&1; then
            log_warn "xrandr not found"
            return 0
        fi

        output=$(xrandr | awk '/ connected primary/ {print $1; exit} / connected/ {print $1; exit}')

        if [ -z "$output" ]; then
            log_warn "No connected display found"
            return 0
        fi

        xrandr --output "$output" --primary --mode 1920x1080 --pos 0x0 --rotate normal || {
            log_warn "Failed to apply xrandr settings to $output"
            return 1
        }

        printf 'Display settings applied to output: %s\n' "$output"
    fi
}

handle_qemu_template() {
    result=$(get_virtualization_type_portable)
    template_xml="$SETTINGS_DIR/qemu-template/kiro-template.xml"
    disk="/var/lib/libvirt/images/kiro-template.qcow2"

    log_section "QEMU/KVM template"
    printf 'Result: %s\n\n' "$result"

    if [ "$result" != "none" ]; then
        log_warn "Virtual machine detected ($result) - skipping QEMU template"
        return 0
    fi

    # virsh/qemu-img come from the QEMU stack; install-qemu.sh sets it up.
    if ! command -v virsh >/dev/null 2>&1 || ! command -v qemu-img >/dev/null 2>&1; then
        log_warn "QEMU/KVM not installed - run scripts/install-qemu.sh first; skipping template"
        return 0
    fi

    if [ ! -f "$template_xml" ]; then
        log_warn "Template not found: $template_xml"
        return 1
    fi

    enable_now_service libvirtd.service

    log_subsection "Ensuring default storage pool"
    if sudo virsh -c qemu:///system pool-info default >/dev/null 2>&1; then
        log_info "Storage pool default already exists"
    else
        sudo virsh -c qemu:///system pool-define-as default dir --target /var/lib/libvirt/images
        sudo virsh -c qemu:///system pool-build default
        sudo virsh -c qemu:///system pool-start default
        sudo virsh -c qemu:///system pool-autostart default
    fi

    log_subsection "Creating empty 40G template disk if absent"
    if [ -f "$disk" ]; then
        log_info "Disk already exists: $disk"
    else
        sudo qemu-img create -f qcow2 "$disk" 40G
    fi

    log_subsection "Defining kiro-template domain"
    if sudo virsh -c qemu:///system dominfo kiro-template >/dev/null 2>&1; then
        log_info "Domain kiro-template already defined"
    else
        sudo virsh -c qemu:///system define "$template_xml"
    fi
}

remove_vm_software_if_real_hardware() {
    result=$(get_virtualization_type_portable)

    log_section "Removal of virtual machine software"

    if [ "$result" = "none" ]; then
        printf '%s\n' "Running on real hardware. Proceeding with cleanup..."

        if command -v systemctl >/dev/null 2>&1; then
            if systemctl list-units --full --all 2>/dev/null | grep -q 'qemu-guest-agent.service'; then
                sudo systemctl stop qemu-guest-agent.service
                sudo systemctl disable qemu-guest-agent.service
            fi

            if systemctl list-units --full --all 2>/dev/null | grep -q 'vboxservice.service'; then
                sudo systemctl stop vboxservice.service
                sudo systemctl disable vboxservice.service
            fi
        fi

        remove_matching_packages qemu-guest-agent
        remove_matching_packages virtualbox-guest-utils
    else
        printf 'Virtual machine detected (%s). No action taken.\n' "$result"
    fi
}

configure_gnupg_keyserver() {
    log_subsection "Configuring GnuPG keyserver"

    local gpg_conf="/etc/pacman.d/gnupg/gpg.conf"
    local keyserver_line="keyserver hkp://keyserver.ubuntu.com:80"

    if [ ! -f "$gpg_conf" ]; then
        log_info "GnuPG gpg.conf not found: $gpg_conf"
        return 0
    fi

    if grep -q "^keyserver hkp://keyserver.ubuntu.com:80$" "$gpg_conf"; then
        log_info "Keyserver already configured in $gpg_conf"
        return 0
    fi

    printf '%s\n' "$keyserver_line" | sudo tee -a "$gpg_conf" >/dev/null || {
        log_warn "Failed to write keyserver configuration"
        return 1
    }

    log_info "Keyserver configured: $keyserver_line"
}

handle_virtualbox_template
handle_qemu_template
remove_vm_software_if_real_hardware
configure_gnupg_keyserver

log_subsection "$(script_name) done"