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

##################################################################################################################################
# Purpose
# - Install archiso if needed
# - Build an Arch Linux ISO using the releng profile
# - Move the ISO to the user's home directory
##################################################################################################################################

main() {

    local answer=""
    local work_dir="/tmp/archiso-work"
    local out_dir="/tmp/archiso-out"
    local iso_file=""

    log_section "Create Arch Linux ISO"

    read -r -p "Do you want to create an Arch Linux ISO? (yes/no): " answer

    if [[ ! "$answer" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
        log_warn "Aborted. No ISO created."
        exit 0
    fi

    log_subsection "Installing archiso if required"
    install_packages archiso

    log_subsection "Building ISO using releng profile"

    sudo mkarchiso -v -w "${work_dir}" -o "${out_dir}" /usr/share/archiso/configs/releng/

    iso_file="$(find "${out_dir}" -name "*.iso" | head -n1 || true)"

    if [[ -f "${iso_file}" ]]; then
        log_subsection "Moving ISO to /home/${USER}"
        cp "${iso_file}" "/home/${USER}/"
        log_success "ISO created and moved to /home/${USER}"
    else
        log_warn "ISO not found in ${out_dir}"
    fi
}

main "$@"