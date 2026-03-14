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
# - Install XAMPP from the AUR
# - Download the latest WordPress release
# - Extract and install WordPress into /opt/lampp/htdocs/wordpress
# - Start XAMPP after installation
##################################################################################################################################

main() {
    local wp_url="https://wordpress.org/latest.tar.gz"
    local install_dir="/opt/lampp/htdocs/wordpress"
    local owner="${SUDO_USER:-$USER}"
    local tmp_dir=""
    local tar_file=""

    tmp_dir="$(mktemp -d)"
    tar_file="${tmp_dir}/latest.tar.gz"

    trap 'rm -rf -- "${tmp_dir:-}"' EXIT

    log_section "Installing XAMPP and WordPress"

    ############################################################################################################
    # Install XAMPP
    ############################################################################################################

    log_subsection "Installing XAMPP"
    install_aur_package xampp

    ############################################################################################################
    # Download and extract WordPress
    ############################################################################################################

    log_subsection "Downloading latest WordPress"
    download_file "${wp_url}" "${tar_file}"

    log_subsection "Extracting WordPress"
    tar -xzf "${tar_file}" -C "${tmp_dir}"

    ############################################################################################################
    # Install WordPress
    ############################################################################################################

    log_subsection "Installing WordPress into ${install_dir}"
    sudo mkdir -p /opt/lampp/htdocs
    sudo rm -rf -- "${install_dir}"
    sudo cp -r "${tmp_dir}/wordpress" "${install_dir}"

    log_subsection "Setting ownership"
    sudo chown -R "${owner}:${owner}" "${install_dir}"

    ############################################################################################################
    # Start XAMPP
    ############################################################################################################

    log_subsection "Starting XAMPP"
    sudo xampp start

    log_success "WordPress installed in ${install_dir}"
    log_info "Open http://localhost/wordpress and http://localhost/phpmyadmin/"
}

main "$@"