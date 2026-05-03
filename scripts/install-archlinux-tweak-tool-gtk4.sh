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
# - Install archlinux-tweak-tool-gtk4 (ATT) from PKGBUILD
# - Source: https://github.com/erikdubois/archlinux-tweak-tool-gtk4
# - PKGBUILD: https://github.com/erikdubois/edu-pkgbuild/tree/main/archlinux-tweak-tool-gtk4-git
##################################################################################################################################

PKGBUILD_BASE="https://raw.githubusercontent.com/erikdubois/edu-pkgbuild/main/archlinux-tweak-tool-gtk4-git"

main() {
    if [[ $EUID -eq 0 ]]; then
        echo "Do not run this script as root — makepkg requires a regular user."
        exit 1
    fi

    log_section "Installing archlinux-tweak-tool-gtk4"

    log_subsection "Installing dependencies"
    install_packages \
        xorg-xauth \
        python-gobject \
        polkit-gnome \
        python-distro \
        python-psutil \
        git

    log_subsection "Building from PKGBUILD"

    BUILD_DIR=$(mktemp -d)
    trap 'rm -rf "$BUILD_DIR"' EXIT

    curl -fsSL "${PKGBUILD_BASE}/PKGBUILD"       -o "${BUILD_DIR}/PKGBUILD"
    curl -fsSL "${PKGBUILD_BASE}/readme.install"  -o "${BUILD_DIR}/readme.install"

    cd "$BUILD_DIR"
    makepkg -si --noconfirm

    log_success "archlinux-tweak-tool-gtk4 installed successfully"
}

main "$@"
