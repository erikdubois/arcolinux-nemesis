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

    local count=0
    local pkg

    for pkg in "${packages[@]}"; do
        ((++count))
        log_subsection "Installing package nr. ${count} ${pkg}"
        install_packages "${pkg}"
    done
}

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

install_virtualbox_guest_utils_if_needed() {
    if command -v systemd-detect-virt >/dev/null 2>&1; then
        if systemd-detect-virt | grep -q "oracle"; then
            sudo add-virtualbox-guest-utils
        fi
    fi
}

if [[ -f /tmp/install-chadwm || "$(basename "$0")" == "600-chadwm.sh" ]]; then
    log_section "Let us install Chadwm"

    install_chadwm_packages
    install_virtualbox_guest_utils_if_needed
    configure_sddm_autologin
fi

log_subsection "$(script_name) done"