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
# - Backup current /etc/pacman.conf if needed
# - Install custom pacman.conf from this script directory
##################################################################################################################################

main() {

    log_section "Installing custom pacman.conf"

    ############################################################################################################
    # Backup pacman.conf if needed
    ############################################################################################################

    backup_file_once /etc/pacman.conf /etc/pacman.conf.nemesis

    ############################################################################################################
    # Copy new pacman.conf
    ############################################################################################################

    copy_file "${PROJECT_DIR}/pacman.conf" /etc/pacman.conf

    log_success "pacman.conf updated"
}

main "$@"