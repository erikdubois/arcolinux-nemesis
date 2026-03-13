#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

install_cups_packages() {
    log_section "Installing cups and scanner packages"

    install_packages \
        cups \
        cups-pdf \
        ghostscript \
        gsfonts \
        gutenprint \
        gtk3-print-backends \
        libcups \
        system-config-printer \
        sane \
        simple-scan
}

enable_cups_service() {
    log_section "Enabling cups service"
    enable_now_service cups.service
}

install_cups_packages
enable_cups_service

log_subsection "$(script_name) done"