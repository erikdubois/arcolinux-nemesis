#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
#####################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#####################################################################
# SSH into the "Kiro" VirtualBox VM with full automatic setup.
#
# AUTOMATIC (script handles):
#   - VBoxManage NAT port-forwarding rule (running: controlvm; stopped: modifyvm)
#   - Stale known_hosts cleanup
#   - sshpass availability check
#   - VM state detection with per-state guidance
#   - Connection retry with guest-setup guide on first failure
#
# MANUAL (one-time inside the guest — shown on connection failure):
#   1. sudo pacman -S openssh
#   2. sudo systemctl enable --now sshd
#   3. Ensure user 'erik' exists with password 'erik'
#####################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ───────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    CYAN=$(tput setaf 6)
    RESET=$(tput sgr0)
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

# ── Log functions ─────────────────────────────────────────────────────────────
log_section() { echo "${GREEN}############################################${RESET}"; echo "${GREEN}  $*${RESET}"; echo "${GREEN}############################################${RESET}"; }
log_info()    { echo "${BLUE}############################################${RESET}";  echo "${BLUE}  $*${RESET}";  echo "${BLUE}############################################${RESET}"; }
log_warn()    { echo "${YELLOW}############################################${RESET}"; echo "${YELLOW}  $*${RESET}"; echo "${YELLOW}############################################${RESET}"; }
log_error()   { echo "${RED}############################################${RESET}";   echo "${RED}  $*${RESET}";   echo "${RED}############################################${RESET}"; }
log_success() { echo "${GREEN}############################################${RESET}"; echo "${GREEN}  $*${RESET}"; echo "${GREEN}############################################${RESET}"; }

# ── Error handler ─────────────────────────────────────────────────────────────
on_error() {
    log_error "ERROR on line $1: $2"
    sleep 10
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

# ── Config ────────────────────────────────────────────────────────────────────
VM_NAME="Kiro"
VM_USER="erik"
VM_HOST="127.0.0.1"
VM_PORT="2022"
VM_PASS="erik"
NAT_RULE_NAME="ssh-kiro"

# ── Functions ─────────────────────────────────────────────────────────────────

check_virtualbox() {
    log_section "Checking VirtualBox"
    if ! command -v VBoxManage &>/dev/null; then
        log_error "VBoxManage not found — install VirtualBox first."
        exit 1
    fi
    log_info "VBoxManage $(VBoxManage --version)"
}

check_vm_exists() {
    log_section "Looking for VM: ${VM_NAME}"
    if ! VBoxManage list vms | grep -q "\"${VM_NAME}\""; then
        log_error "VM '${VM_NAME}' not found."
        echo ""
        echo "${YELLOW}  Available VMs:${RESET}"
        VBoxManage list vms
        echo ""
        echo "${CYAN}  Edit VM_NAME at the top of this script to match one of the above.${RESET}"
        exit 1
    fi
    log_info "VM '${VM_NAME}' found"
}

get_vm_state() {
    VBoxManage showvminfo "${VM_NAME}" --machinereadable \
        | grep '^VMState=' | cut -d'"' -f2
}

rule_exists() {
    # NAT rule format in machinereadable output: natpf1="ssh-kiro,tcp,,2022,,22"
    # Match on opening quote + name + comma to avoid false positives.
    VBoxManage showvminfo "${VM_NAME}" --machinereadable \
        | grep -q "\"${NAT_RULE_NAME},"
}

setup_port_forwarding() {
    log_section "NAT port forwarding: host:${VM_PORT} → guest:22"

    if rule_exists; then
        log_info "Rule '${NAT_RULE_NAME}' already present — skipping"
        return
    fi

    local state
    state=$(get_vm_state)

    if [[ "${state}" == "running" ]]; then
        # controlvm works on a live VM
        VBoxManage controlvm "${VM_NAME}" natpf1 delete "${NAT_RULE_NAME}" 2>/dev/null || true
        VBoxManage controlvm "${VM_NAME}" natpf1 "${NAT_RULE_NAME},tcp,,${VM_PORT},,22"
    else
        # modifyvm requires the VM to be off
        VBoxManage modifyvm "${VM_NAME}" --natpf1 delete "${NAT_RULE_NAME}" 2>/dev/null || true
        VBoxManage modifyvm "${VM_NAME}" --natpf1 "${NAT_RULE_NAME},tcp,,${VM_PORT},,22"
    fi

    log_success "Rule added: host:${VM_PORT} → guest:22"
}

print_start_vm_guide() {
    echo ""
    log_warn "VM is off — start it, then re-run this script"
    echo ""
    echo "${CYAN}    1. Start VM '${VM_NAME}' in VirtualBox${RESET}"
    echo "${CYAN}    2. Inside the VM, run once if not already done:${RESET}"
    echo "${CYAN}         sudo pacman -S openssh${RESET}"
    echo "${CYAN}         sudo systemctl enable --now sshd${RESET}"
    echo "${CYAN}         id erik &>/dev/null || sudo useradd -m erik${RESET}"
    echo "${CYAN}         echo 'erik:erik' | sudo chpasswd${RESET}"
    echo "${CYAN}    3. Re-run this script to connect${RESET}"
    echo ""
}

print_guest_prerequisites() {
    echo ""
    log_warn "Connection failed — complete these steps inside the VM console"
    echo ""
    echo "${CYAN}    sudo pacman -S openssh${RESET}"
    echo "${CYAN}    sudo systemctl enable --now sshd${RESET}"
    echo ""
    echo "${CYAN}    # Create user 'erik' with password 'erik' if missing:${RESET}"
    echo "${CYAN}    id erik &>/dev/null || sudo useradd -m erik${RESET}"
    echo "${CYAN}    echo 'erik:erik' | sudo chpasswd${RESET}"
    echo ""
    read -r -p "  Press Enter when ready to retry, or Ctrl+C to abort: " || true
    echo ""
}

clean_known_hosts() {
    ssh-keygen -R "[${VM_HOST}]:${VM_PORT}" 2>/dev/null || true
}

check_sshpass() {
    log_section "Checking sshpass"
    if ! command -v sshpass &>/dev/null; then
        log_warn "sshpass not installed (needed for password login)."
        echo ""
        echo "${CYAN}  Install it with:  sudo pacman -S sshpass${RESET}"
        echo ""
        read -r -p "  Press Enter after installing sshpass, or Ctrl+C to abort: " || true
        if ! command -v sshpass &>/dev/null; then
            log_error "sshpass still not found. Aborting."
            exit 1
        fi
    fi
    log_info "sshpass found"
}

ssh_connect() {
    sshpass -p "${VM_PASS}" ssh \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o ConnectTimeout=5 \
        -p "${VM_PORT}" \
        "${VM_USER}@${VM_HOST}"
}

do_connect() {
    log_section "Connecting to ${VM_NAME}"
    log_info "${VM_USER}@${VM_HOST} port ${VM_PORT}"
    clean_known_hosts

    if ssh_connect; then
        return
    fi

    # First attempt failed — show guest setup guide, then retry without timeout
    print_guest_prerequisites
    clean_known_hosts
    sshpass -p "${VM_PASS}" ssh \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -p "${VM_PORT}" \
        "${VM_USER}@${VM_HOST}"
}

# ── Main ──────────────────────────────────────────────────────────────────────

main() {
    check_virtualbox
    check_vm_exists
    setup_port_forwarding

    local state
    state=$(get_vm_state)
    log_info "VM '${VM_NAME}' state: ${state}"

    if [[ "${state}" != "running" ]]; then
        print_start_vm_guide
        log_success "$(basename "$0") — setup done, start the VM and re-run to connect"
        exit 0
    fi

    check_sshpass
    do_connect

    log_success "$(basename "$0") done"
}

main "$@"
