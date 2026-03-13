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
##################################################################################################################################

install_aur_package_if_needed() {
    local pkg="$1"

    if pacman -Qi "${pkg}" &>/dev/null; then
        echo "${pkg} is already installed."
    else
        log_subsection "Installing ${pkg} from AUR"
		if ! command -v yay >/dev/null; then
			log_error "$LINENO" "yay not installed"
			return 1
		fi
        yay -S --noconfirm "${pkg}"
    fi
}

log_section "Build Opera from AUR"

install_aur_package_if_needed opera

log_subsection "$(script_name) done"