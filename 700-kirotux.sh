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
#   - Put back the apps the KIROTUX ISO leaves out compared to the Kiro ISO.
#   - Skip cleanly when the system was not installed from a KIROTUX ISO.
#
##################################################################################################################################

install_kirotux_extras() {
    # /etc/dev-rel is written by the ISO and survives the install.
    if ! grep -q "^ISO_CODENAME=kirotux" /etc/dev-rel 2>/dev/null; then
        log_warn "Not a KIROTUX install - skipping KIROTUX extras"
        return 0
    fi

    log_section "KIROTUX detected - installing the apps the ISO leaves out"

    install_packages brave-bin chromium vivaldi vivaldi-ffmpeg-codecs visual-studio-code-bin claude-code \
        gimp inkscape obs-studio qbittorrent neo-candy-icons-git
}

install_kirotux_extras

log_subsection "$(script_name) done"
