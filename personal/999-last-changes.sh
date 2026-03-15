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

run_hardcode_fixer() {

    log_section "Changing icons - hardcode-fixer"

    echo "Checking if icons from applications have a hardcoded path"
    echo "and fixing them"
    echo "Wait for it ..."

    sudo hardcode-fixer
}

run_hardcode_fixer

log_subsection "$(script_name) done"