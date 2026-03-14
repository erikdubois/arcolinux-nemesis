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
# - Install XAMPP
# - Download the latest WordPress release
# - Install WordPress into /opt/lampp/htdocs/wordpress
##################################################################################################################################

main() {
    local wp_url="https://wordpress.org/latest.tar.gz"
    local install_dir="/opt/lampp/htdocs/wordpress"
    local owner="${SUDO_USER:-$USER}"
    local tmp_dir
    local tar_file

    tmp_dir="$(mktemp -d)"
    tar_file="${tmp_dir}/latest.tar.gz"

    trap 'rm -rf "${tmp_dir}"' EXIT

    log_section "Installing XAMPP and WordPress"

    if pkg_installed xampp; then
        log_info "xampp is already installed"
    else
        log_subsection "Installing xampp with yay"
        yay -S --noconfirm --needed xampp
    fi

    log_subsection "Downloading latest WordPress"
    sudo curl -fL "${wp_url}" -o "${tar_file}"

    log_subsection "Extracting WordPress"
    tar -xzf "${tar_file}" -C "${tmp_dir}"

    log_subsection "Installing WordPress into ${install_dir}"
    sudo rm -rf "${install_dir}"
    sudo mkdir -p /opt/lampp/htdocs
    sudo cp -r "${tmp_dir}/wordpress" "${install_dir}"

    log_subsection "Setting ownership"
    sudo chown -R "${owner}:${owner}" "${install_dir}"

    log_subsection "Starting XAMPP"
    sudo xampp start

    log_success "WordPress installed in ${install_dir}"
    log_info "Open http://localhost/wordpress and http://localhost/phpmyadmin/"
}

main "$@"