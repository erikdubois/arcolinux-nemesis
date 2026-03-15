#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

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
##################################################################################################################################

install_hwinfo_if_needed() {
    if ! command -v hwinfo >/dev/null 2>&1; then
        log_subsection "Installing hwinfo"
        install_packages hwinfo
    fi
}

install_ckb_next_if_keyboard_detected() {

    if hwinfo | grep -q "CORSAIR K70"; then

        log_section "Corsair keyboard detected - installing ckb-next"

        install_packages ckb-next-git

        mkdir -p "${HOME}/.config/ckb-next"
        mkdir -p "${HOME}/.config/autostart"

        copy_file \
            "${PROJECT_DIR}/Personal/settings/ckb-next/ckb-next.conf" \
            "${HOME}/.config/ckb-next/ckb-next.conf"

        copy_file \
            "${PROJECT_DIR}/Personal/settings/ckb-next/ckb-next.autostart.desktop" \
            "${HOME}/.config/autostart/ckb-next.autostart.desktop"

        enable_service ckb-next-daemon.service
        start_service ckb-next-daemon.service

        log_section "Corsair keyboard configured"

    fi
}

install_hwinfo_if_needed
install_ckb_next_if_keyboard_detected

log_subsection "$(script_name) done"