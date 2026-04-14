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

systemd_no_coredump() {
    conf_dir="/etc/systemd/coredump.conf.d"
    conf_file="$conf_dir/custom.conf"
    expected_content="[Coredump]
Storage=none
ProcessSizeMax=0"

    log_section "Disabling systemd coredumps"

    if [ -f "$conf_file" ] &&
       grep -q "Storage=none" "$conf_file" &&
       grep -q "ProcessSizeMax=0" "$conf_file"; then
        log_info "Coredump config already present: $conf_file"
        return 0
    fi

    sudo mkdir -p "$conf_dir" || {
        log_warn "Failed to create directory: $conf_dir"
        return 1
    }

    printf '%s\n' "$expected_content" | sudo tee "$conf_file" >/dev/null || {
        log_warn "Failed to write: $conf_file"
        return 1
    }

    log_info "Coredump config written: $conf_file"
}

harden_kernel() {
    sysctl_dir="/etc/sysctl.d"
    sysctl_file="$sysctl_dir/99-hardening.conf"

    log_section "Kernel hardening"

    if [ -f "$sysctl_file" ]; then
        log_info "Hardening config already present: $sysctl_file"
        return 0
    fi

    sudo mkdir -p "$sysctl_dir" || {
        log_warn "Failed to create directory: $sysctl_dir"
        return 1
    }

    sudo tee "$sysctl_file" >/dev/null <<'EOF'
# Kernel hardening parameters - 930-real-metal.sh
# Privacy: Hide kernel pointers and restrict debug access
kernel.sysrq = 0
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.yama.ptrace_scope = 2
kernel.unprivileged_bpf_disabled = 1
kernel.perf_event_paranoid = 3

# Core dumps: Prevent unintended core dump leaks
kernel.core_uses_pid = 1
fs.suid_dumpable = 0

# Network: Basic hardening (SYN cookies, no redirects)
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.tcp_syncookies = 1
EOF

    if [ $? -ne 0 ]; then
        log_warn "Failed to write: $sysctl_file"
        return 1
    fi

    if command -v sysctl >/dev/null 2>&1; then
        sudo sysctl -p "$sysctl_file" >/dev/null 2>&1 || {
            log_warn "Failed to apply sysctl settings"
            return 1
        }
        log_info "Kernel hardening applied and made persistent"
    else
        log_warn "sysctl not found - settings written but not applied"
        return 1
    fi
}

swappiness() {
    sysctl_dir="/etc/sysctl.d"
    sysctl_file="$sysctl_dir/99-swappiness.conf"

    log_section "Setting swappiness"

    if [ -f "$sysctl_file" ]; then
        log_info "Swappiness config already present: $sysctl_file"
        return 0
    fi

    sudo mkdir -p "$sysctl_dir" || {
        log_warn "Failed to create directory: $sysctl_dir"
        return 1
    }

    sudo tee "$sysctl_file" >/dev/null <<'EOF'
# Swappiness parameter - 930-real-metal.sh
vm.swappiness = 10
EOF

    if [ $? -ne 0 ]; then
        log_warn "Failed to write: $sysctl_file"
        return 1
    fi

    if command -v sysctl >/dev/null 2>&1; then
        sudo sysctl -p "$sysctl_file" >/dev/null 2>&1 || {
            log_warn "Failed to apply sysctl settings"
            return 1
        }
        log_info "Swappiness applied and made persistent"
    else
        log_warn "sysctl not found - settings written but not applied"
        return 1
    fi
}

handle_virtualbox_template
remove_vm_software_if_real_hardware
systemd_no_coredump
harden_kernel
swappiness

log_subsection "$(script_name) done"