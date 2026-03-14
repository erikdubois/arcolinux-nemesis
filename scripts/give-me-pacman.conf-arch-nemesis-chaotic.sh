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
# - Install local chaotic keyring and mirrorlist packages
# - Backup current pacman.conf
# - Install custom pacman.conf with chaotic repository enabled
##################################################################################################################################

main() {

    local pkg_dir="${PROJECT_DIR}/packages"

    log_section "Installing Chaotic keyring and mirrorlist"

    ############################################################################################################
    # Install local chaotic packages
    ############################################################################################################

    if [[ ! -d "${pkg_dir}" ]]; then
        log_warn "Directory not found: ${pkg_dir}"
        exit 1
    fi

    log_subsection "Installing local packages from ${pkg_dir}"

    install_local_packages_from_dir "${pkg_dir}"
    
    ############################################################################################################
    # Backup pacman.conf
    ############################################################################################################

    backup_file_once /etc/pacman.conf /etc/pacman.conf.nemesis

    ############################################################################################################
    # Install new pacman.conf
    ############################################################################################################

    copy_file "${PROJECT_DIR}/pacman.conf" /etc/pacman.conf

    log_success "pacman.conf updated with chaotic repository"
}

main "$@"