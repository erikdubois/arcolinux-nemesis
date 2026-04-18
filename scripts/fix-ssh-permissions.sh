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
# - Fix permissions on ~/.ssh directory and all key files
##################################################################################################################################

main() {
    local ssh_dir="${HOME}/.ssh"

    if [[ ! -d "${ssh_dir}" ]]; then
        log_warn "~/.ssh directory not found — nothing to do"
        exit 0
    fi

    log_section "Fixing SSH permissions"

    log_subsection "Setting ~/.ssh to 700"
    chmod 700 "${ssh_dir}"

    log_subsection "Setting private keys to 600"
    for f in "${ssh_dir}"/id_* "${ssh_dir}"/authorized_keys "${ssh_dir}"/config; do
        [[ -f "$f" ]] || continue
        [[ "$f" == *.pub ]] && continue
        chmod 600 "$f"
        log_info "600: $f"
    done

    log_subsection "Setting public keys to 644"
    for f in "${ssh_dir}"/*.pub; do
        [[ -f "$f" ]] || continue
        chmod 644 "$f"
        log_info "644: $f"
    done

    log_success "SSH permissions fixed"
}

main "$@"
