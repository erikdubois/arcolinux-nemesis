#!/usr/bin/env bash

##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

set -uo pipefail

##################################################################################################################
# Root Check
##################################################################################################################

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    echo "Please use: sudo $0"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SYSTEMD_BOOT_ENTRIES=""
SYSTEMD_BOOT_CONFIG=""

##################################################################################################################
# Helpers
##################################################################################################################

log_section() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }
log_success() { echo -e "${GREEN}✓ $1${NC}"; }
log_warn()    { echo -e "${YELLOW}⚠ $1${NC}"; }
log_error()   { echo -e "${RED}✗ $1${NC}"; }

detect_systemd_boot_path() {
    if [[ -d "/boot/efi/loader/entries" ]]; then
        SYSTEMD_BOOT_ENTRIES="/boot/efi/loader/entries"
        SYSTEMD_BOOT_CONFIG="/boot/efi/loader/loader.conf"
        return 0
    fi
    if [[ -d "/boot/loader/entries" ]]; then
        SYSTEMD_BOOT_ENTRIES="/boot/loader/entries"
        SYSTEMD_BOOT_CONFIG="/boot/loader/loader.conf"
        return 0
    fi
    return 1
}

check_systemd_boot() {
    if ! detect_systemd_boot_path; then
        log_error "systemd-boot not found"
        log_error "  Checked: /boot/efi/loader/entries"
        log_error "  Checked: /boot/loader/entries"
        return 1
    fi
    log_success "systemd-boot found at: ${SYSTEMD_BOOT_ENTRIES%/entries}"
}

# Read default from EFI NVRAM via bootctl (the authoritative source)
get_efi_default() {
    bootctl status 2>/dev/null | grep "Default Entry:" | awk '{print $NF}' | sed 's/\.conf$//'
}

# Read default from loader.conf
get_loader_default() {
    grep "^default " "$SYSTEMD_BOOT_CONFIG" 2>/dev/null | awk '{print $2}'
}

##################################################################################################################
# List kernels
##################################################################################################################

list_kernels() {
    local entries=()
    local display_names=()
    local i=0

    for entry in "$SYSTEMD_BOOT_ENTRIES"/*.conf; do
        [[ -f "$entry" ]] || continue
        local full_name
        full_name=$(basename "$entry" .conf)
        entries+=("$full_name")
        local display_name="$full_name"
        if [[ "$full_name" =~ -([0-9]+\.[0-9]+.*) ]]; then
            display_name="${BASH_REMATCH[1]}"
        fi
        display_names+=("$display_name")
        ((i++))
    done

    echo "${entries[@]+"${entries[@]}"}"
    echo "${display_names[@]+"${display_names[@]}"}"
}

##################################################################################################################
# Set default kernel
##################################################################################################################

EFI_VAR="/sys/firmware/efi/efivars/LoaderEntryDefault-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"

read_efi_default() {
    if [[ ! -f "$EFI_VAR" ]]; then
        echo ""
        return
    fi
    # Skip 4-byte attribute prefix, decode UTF-16LE to ASCII
    dd if="$EFI_VAR" bs=1 skip=4 2>/dev/null | \
        python3 -c "import sys; data=sys.stdin.buffer.read(); print(data.decode('utf-16-le').rstrip(chr(0)))" 2>/dev/null || echo ""
}

write_efi_default() {
    local kernel_name="$1"
    echo "  Writing EFI variable directly: $EFI_VAR"

    # Make file mutable if immutable flag is set
    chattr -i "$EFI_VAR" 2>/dev/null || true

    python3 - "$kernel_name" "$EFI_VAR" <<'PYEOF'
import sys, struct

kernel_name = sys.argv[1]
efi_var     = sys.argv[2]

# EFI variable format: 4-byte attributes (NV+BS+RT=7) + UTF-16LE string + null terminator
attributes = struct.pack('<I', 7)
payload    = kernel_name.encode('utf-16-le') + b'\x00\x00'

with open(efi_var, 'wb') as f:
    f.write(attributes + payload)

print(f"  Written: {kernel_name}")
PYEOF
}

set_default_kernel() {
    local kernel_name="$1"
    local entry_file="$SYSTEMD_BOOT_ENTRIES/$kernel_name.conf"

    if [[ ! -f "$entry_file" ]]; then
        log_error "Kernel entry not found: $entry_file"
        return 1
    fi

    local efi_before
    efi_before=$(read_efi_default)
    echo "  EFI NVRAM before: ${efi_before:-<empty>}"
    echo

    log_section "Step 1: Write EFI NVRAM directly"
    if write_efi_default "$kernel_name"; then
        log_success "EFI variable written"
    else
        log_error "Failed to write EFI variable"
        return 1
    fi

    log_section "Step 2: Update loader.conf to match"
    sed -i '/^default /d' "$SYSTEMD_BOOT_CONFIG"
    echo "default $kernel_name" >> "$SYSTEMD_BOOT_CONFIG"
    log_success "loader.conf updated"

    return 0
}

##################################################################################################################
# Verify
##################################################################################################################

verify_kernel_change() {
    local expected="$1"

    log_section "Verification"

    local efi_default
    efi_default=$(get_efi_default)
    local loader_default
    loader_default=$(get_loader_default)

    echo "  Expected:      $expected"
    echo "  EFI NVRAM:     ${efi_default:-<not set>}"
    echo "  loader.conf:   ${loader_default:-<not set>}"
    echo

    if [[ "$efi_default" == "$expected" ]]; then
        log_success "EFI NVRAM matches — this is what systemd-boot will boot"
        return 0
    else
        log_error "EFI NVRAM does not match expected kernel"
        log_warn "Expected: $expected"
        log_warn "EFI has:  ${efi_default:-<empty>}"
        return 1
    fi
}

##################################################################################################################
# Select kernel interactively
##################################################################################################################

select_kernel() {
    local entries=()
    local display_names=()

    for entry in "$SYSTEMD_BOOT_ENTRIES"/*.conf; do
        [[ -f "$entry" ]] || continue
        local full_name
        full_name=$(basename "$entry" .conf)
        entries+=("$full_name")
        local display_name="$full_name"
        if [[ "$full_name" =~ -([0-9]+\.[0-9]+.*) ]]; then
            display_name="${BASH_REMATCH[1]}"
        fi
        display_names+=("$display_name")
    done

    if [[ ${#entries[@]} -eq 0 ]]; then
        log_error "No kernel entries found"
        return 1
    fi

    local efi_default
    efi_default=$(get_efi_default)

    log_section "Available Kernels"
    for i in "${!entries[@]}"; do
        local marker=""
        if [[ "${entries[$i]}" == "$efi_default" ]]; then
            marker=" ← current EFI default"
        fi
        echo "  [$((i+1))] ${display_names[$i]}$marker"
    done
    echo

    read -rp "Enter selection (1-${#entries[@]}): " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#entries[@]} )); then
        log_error "Invalid selection"
        return 1
    fi

    local selected="${entries[$((choice-1))]}"

    if set_default_kernel "$selected"; then
        if verify_kernel_change "$selected"; then
            log_success "Done! Reboot to boot the new default kernel."
            echo
            echo "  sudo reboot"
            echo
        else
            log_error "Verification failed — check bootctl status manually"
            return 1
        fi
    else
        log_error "Failed to set default kernel"
        return 1
    fi
}

##################################################################################################################
# Main
##################################################################################################################

main() {
    log_section "systemd-boot Kernel Boot Sequence Changer"

    check_systemd_boot || exit 1

    local efi_default
    efi_default=$(get_efi_default)
    local loader_default
    loader_default=$(get_loader_default)

    echo "  EFI NVRAM default:   ${efi_default:-<not set>}"
    echo "  loader.conf default: ${loader_default:-<not set>}"

    select_kernel
}

main "$@"
