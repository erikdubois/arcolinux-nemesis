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
#   - Install Ananicy and its rule set.
#   - Enable the service so process priority tuning starts immediately.
#
##################################################################################################################################

install_ananicy_packages() {
    log_section "Installing Ananicy packages"

    install_packages         ananicy-cpp         cachyos-ananicy-rules
}

enable_ananicy_service() {
    log_section "Enabling Ananicy service"
    enable_now_service ananicy-cpp.service
}

install_ananicy_packages
enable_ananicy_service

log_subsection "$(script_name) done"
