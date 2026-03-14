#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install yay or paru AUR helpers
##################################################################################################################################

install_from_aur() {
    local pkg="$1"
    local url="https://aur.archlinux.org/cgit/aur.git/snapshot/${pkg}.tar.gz"
    local tmp

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' RETURN

    log_subsection "Building ${pkg}"

    cd "$tmp"
    curl -LO "$url"
    tar -xf "${pkg}.tar.gz"
    cd "$pkg"

    makepkg -si --noconfirm
}

main() {

    log_section "Install AUR helper"

    echo "1) yay-git"
    echo "2) paru-git"
    echo "3) both"
    echo "*) exit"

    read -rp "Choose: " choice

    case "$choice" in
        1) install_from_aur yay-git ;;
        2) install_from_aur paru-git ;;
        3)
            install_from_aur yay-git
            install_from_aur paru-git
            ;;
        *) log_info "Exiting"; exit 0 ;;
    esac

    log_success "AUR helper installation finished"
}

main "$@"