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
# - Install Belgian eID middleware
# - Enable smartcard support
##################################################################################################################################

main() {
    log_section "Installing Belgian eID middleware"

    install_packages pcsclite ccid opensc
    enable_now_service pcscd

    log_subsection "Importing GPG key"
    gpg --recv-key 824A5E0010A04D46

    if pkg_installed eid-mw; then
        log_info "eid-mw is already installed"
    else
        log_subsection "Installing eid-mw with yay"
        yay -S --noconfirm eid-mw
    fi

    log_success "Belgian eID setup completed"
}

main "$@"