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
# - Install Samba packages
# - Copy Samba configuration
# - Enable Samba services
##################################################################################################################################

main() {
    local username=""

    log_section "Installing Samba"

    install_packages samba gvfs-smb gvfs-dnssd

    copy_file "${PROJECT_DIR}/smb.conf.nemesis" /etc/samba/smb.conf

    echo
    read -r -p "What is your login? It will be used for Samba: " username

    sudo smbpasswd -a "${username}"

    enable_service smb.service
    enable_service nmb.service

    log_success "Samba installation completed"
}

main "$@"