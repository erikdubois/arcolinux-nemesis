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
# - Copy the ISO to the real invoking user's home directory
##################################################################################################################################

main() {

    local target_user="${SUDO_USER:-$USER}"
    local target_home=""
    local work_dir="/tmp/archiso-work"
    local out_dir="/tmp/archiso-out"
    local iso_file=""

    log_section "Create Arch Linux ISO"

    if ! confirm_yes_no "Do you want to create an Arch Linux ISO?"; then
        log_warn "Aborted. No ISO created."
        exit 0
    fi

    target_home="$(getent passwd "${target_user}" | cut -d: -f6)"

    if [[ -z "${target_home}" || ! -d "${target_home}" ]]; then
        log_warn "Could not determine a valid home directory for user ${target_user}"
        exit 1
    fi

    ############################################################################################################
    # Install required packages
    ############################################################################################################

    log_subsection "Installing archiso if required"
    install_packages archiso

    ############################################################################################################
    # Build the ISO
    ############################################################################################################

    log_subsection "Building ISO using releng profile"
    sudo mkarchiso -v -w "${work_dir}" -o "${out_dir}" /usr/share/archiso/configs/releng/

    iso_file="$(find "${out_dir}" -type f -name "*.iso" | head -n 1 || true)"

    if [[ -z "${iso_file}" || ! -f "${iso_file}" ]]; then
        log_warn "ISO not found in ${out_dir}"
        exit 1
    fi

    ############################################################################################################
    # Copy ISO to target user home
    ############################################################################################################

    log_subsection "Copying ISO to ${target_home}"
    sudo cp "${iso_file}" "${target_home}/"
    sudo chown "${target_user}:${target_user}" "${target_home}/$(basename "${iso_file}")"

    log_success "ISO created and copied to ${target_home}"
}

main "$@"