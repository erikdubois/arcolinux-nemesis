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
# - Set Belgian AZERTY keyboard for console
# - Set Belgian keyboard as the system default XKB layout
# - Set system locale to en_US.UTF-8
##################################################################################################################################

main() {
    log_section "Setting Belgian AZERTY keyboard and locale"

    sudo localectl set-keymap be-latin1
    sudo localectl set-x11-keymap be
    sudo localectl set-locale LANG=en_US.UTF-8

    log_success "Belgian AZERTY keyboard configured"
    log_warn "Wayland compositors may still override this with their own keyboard settings"
    log_warn "Reboot or log out and back in to apply everywhere possible"
}

main "$@"