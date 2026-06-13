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
# - Append nemesis_repo and chaotic-aur to pacman.conf if not already present
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

    backup_file_once /etc/pacman.conf /etc/pacman.conf-nemesis

    ############################################################################################################
    # Append nemesis_repo and chaotic-aur to pacman.conf if not already present
    ############################################################################################################

    if ! grep -q "\[nemesis_repo\]" /etc/pacman.conf; then
        printf '\n[nemesis_repo]\nServer = https://erikdubois.github.io/$repo/$arch\n' \
            | tee -a /etc/pacman.conf > /dev/null
        log_info "nemesis_repo added to pacman.conf"
    else
        log_info "nemesis_repo already present in pacman.conf"
    fi

    if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        printf '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' \
            | tee -a /etc/pacman.conf > /dev/null
        log_info "chaotic-aur added to pacman.conf"
    else
        log_info "chaotic-aur already present in pacman.conf"
    fi

    log_success "pacman.conf updated with nemesis_repo and chaotic-aur"
}

main "$@"