#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR
SETTINGS_DIR="${SCRIPT_DIR}/settings"
echo $SETTINGS_DIR

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

apply_plasma_specific_settings() {
    if [[ ! -f /usr/bin/startplasma-x11 ]]; then
        return 0
    fi

    log_section "Plasma specific"

    log_subsection "$(script_name) done"
}

apply_plasma_specific_settings