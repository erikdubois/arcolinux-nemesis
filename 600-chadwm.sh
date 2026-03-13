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
#   - Install the Chadwm stack and related XFCE utilities.
#   - Replace conflicting ArcoLinux packages when necessary.
#   - Configure SDDM autologin for the current user.
#
##################################################################################################################################

install_chadwm_packages() {
    log_section "Install Chadwm"

    local packages=(
        make
        alacritty
        archlinux-logout-git
        edu-chadwm-git
        edu-xfce-git
        autorandr
        dash
        dmenu
        feh
        gcc
        gvfs
        lolcat
        lxappearance
        picom-git
        polkit-gnome
        rofi
        sxhkd
        thunar
        thunar-archive-plugin
        thunar-volman
        ttf-hack
        ttf-font-awesome
        ttf-jetbrains-mono-nerd
        ttf-meslo-nerd-font-powerlevel10k
        volumeicon
        xfce4-notifyd
        xfce4-power-manager
        xfce4-screenshooter
        xfce4-settings
        xfce4-taskmanager
        xfce4-terminal
        xorg-xsetroot
    )

    # Install sequentially for better logging visibility.
    local count=0
    local pkg

    for pkg in "${packages[@]}"; do
        ((++count))
        log_subsection "Installing package nr. ${count} ${pkg}"
        install_packages "${pkg}"
    done
}

# Warn ArcoLinux users before package replacement starts.
show_arcolinux_warning_if_needed() {
    if [[ -f /etc/dev-rel ]]; then
        log_warn "You are running this nemesis script on an ArcoLinux system
In order to avoid package conflicts you should first run
100-remove-software.sh to remove ArcoLinux packages.
The ArcoLinux packages need to be replaced with the edu-packages
from the nemesis_repo that should already be declared in
your /etc/pacman.conf"
        sleep 2
    fi
}

# Create or refresh the SDDM drop-in file used for autologin.
configure_sddm_autologin() {
    local target_dir="/etc/sddm.conf.d"
    local target_file="${target_dir}/kde_settings.conf"
    local tmp_file

    if [[ -f /usr/local/bin/fix-sddm-conf ]]; then
        fix-sddm-conf
    else
        sudo mkdir -p "${target_dir}"

        tmp_file="$(mktemp)"
        cat > "${tmp_file}" <<EOF
[Autologin]
User=${USER}
Session=

[General]
InputMethod=
Numlock=on
EOF

        sudo mv "${tmp_file}" "${target_file}"
    fi

    log_section "SDDM configuration changed and set User=${USER} at
/etc/sddm.conf.d/kde_settings.conf
Check with 'nsddmk' in a terminal and change the variables when necessary"
}

# Add guest utilities only for VirtualBox guests.
install_virtualbox_guest_utils_if_needed() {
    if command -v systemd-detect-virt >/dev/null 2>&1; then
        if systemd-detect-virt | grep -q "oracle"; then
            sudo add-virtualbox-guest-utils
        fi
    fi
}

show_arcolinux_warning_if_needed

# Remove overlapping Arco packages before installing the edu/Nemesis stack.
remove_matching_packages arcolinux-rofi-git
remove_matching_packages arcolinux-rofi-themes-git
remove_matching_packages arcolinux-chadwm-git
remove_matching_packages arconet-xfce
remove_matching_packages lxappearance

# Install Chadwm either when the marker file exists or when this script is
# launched directly by name.
if [[ -f /tmp/install-chadwm || "$(basename "$0")" == "600-chadwm.sh" ]]; then
    log_section "Let us install Chadwm"

    install_chadwm_packages
    install_virtualbox_guest_utils_if_needed
    configure_sddm_autologin
fi

log_subsection "$(script_name) done"
