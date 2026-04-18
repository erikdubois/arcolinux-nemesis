#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

pause_if_debug

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   - Install printing and scanning support.
#   - Enable the CUPS service immediately after installation.
#
##################################################################################################################################

install_cups_packages() {
    log_section "Installing cups and scanner packages"

    # Keep printing and scanning together because both are part of the same
    # workstation setup phase for most users.
    install_packages cups cups-pdf ghostscript gsfonts gutenprint libcups         system-config-printer         sane         simple-scan
}

enable_cups_service() {
    log_section "Enabling cups service"
    enable_now_service cups.service
}

install_cups_packages
enable_cups_service

log_subsection "$(script_name) done"
