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
# - Install local chaotic keyring and mirrorlist packages
# - Backup current pacman.conf
# - Install custom pacman.conf with chaotic repository enabled
##################################################################################################################################

main() {

    local pkg_dir="${SCRIPT_DIR}/../../packages"

    log_section "Installing Chaotic keyring and mirrorlist"

    ############################################################################################################
    # Install local chaotic packages
    ############################################################################################################

    if [[ ! -d "${pkg_dir}" ]]; then
        log_warn "Directory not found: ${pkg_dir}"
        exit 1
    fi

    log_subsection "Installing local packages from ${pkg_dir}"

    find "${pkg_dir}" -maxdepth 1 -name '*.pkg.tar.zst' -print0 | sudo xargs -0 pacman -U --noconfirm

    ############################################################################################################
    # Backup pacman.conf
    ############################################################################################################

    backup_file_once /etc/pacman.conf /etc/pacman.conf.nemesis

    ############################################################################################################
    # Install new pacman.conf
    ############################################################################################################

    copy_file "${SCRIPT_DIR}/pacman.conf" /etc/pacman.conf

    log_success "pacman.conf updated with chaotic repository"
}

main "$@"