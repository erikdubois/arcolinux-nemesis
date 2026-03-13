#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

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

copy_skel_to_home() {

    log_section "Final SKEL configuration"

    echo "Copying all files and folders from /etc/skel to HOME"
    echo "First we make a backup of ~/.config"
    echo "Wait for it ...."

    if [[ -d "${HOME}/.config" ]]; then
        local backup_dir="${HOME}/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)"

        log_subsection "Creating backup: ${backup_dir}"
        cp -Rf "${HOME}/.config" "${backup_dir}"
    fi

    log_subsection "Copying /etc/skel to HOME"
    cp -arf /etc/skel/. "${HOME}/"
}

copy_skel_to_home

log_subsection "$(script_name) done"