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
# SSH into riker — real metal Kiro machine on the local network.
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
VM_HOST="192.168.1.43"
VM_USER="erik"
VM_PORT="22"
VM_PASS="erik"

# ── Functions ─────────────────────────────────────────────────────────────────

check_reachable() {
    log_section "Checking riker (${VM_HOST}:${VM_PORT})"
    if ! ping -c 1 -W 2 "${VM_HOST}" &>/dev/null; then
        log_error "Host ${VM_HOST} is not reachable. Is riker on and on the network?"
        exit 1
    fi
    log_info "${VM_HOST} is up"
}

check_sshpass() {
    if ! command -v sshpass &>/dev/null; then
        log_warn "sshpass not installed."
        echo "${CYAN}  Install with:  sudo pacman -S sshpass${RESET}"
        read -r -p "  Press Enter after installing, or Ctrl+C to abort: " || true
        if ! command -v sshpass &>/dev/null; then
            log_error "sshpass still not found. Aborting."
            exit 1
        fi
    fi
}

clean_known_hosts() {
    ssh-keygen -R "[${VM_HOST}]:${VM_PORT}" 2>/dev/null || true
    ssh-keygen -R "${VM_HOST}" 2>/dev/null || true
}

do_connect() {
    log_section "Connecting to riker"
    log_info "${VM_USER}@${VM_HOST} port ${VM_PORT}"
    clean_known_hosts
    sshpass -p "${VM_PASS}" ssh \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -p "${VM_PORT}" \
        "${VM_USER}@${VM_HOST}"
}

# ── Main ──────────────────────────────────────────────────────────────────────

main() {
    check_sshpass
    check_reachable
    do_connect
    log_success "$(basename "$0") done"
}

main "$@"
