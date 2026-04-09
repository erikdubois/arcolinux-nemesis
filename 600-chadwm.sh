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
install_chadwm_package() {
    install_packages edu-chadwm-git
}
install_ohmychadwm_package() {
    install_packages ohmychadwm-git
}

install_core_packages() {
    log_section "Install core packages for Chadwm and/or ohmychadwm"

    local packages=(
        make
        alacritty
        archlinux-logout-gtk4-git
        edu-xfce-git
        dash
        dmenu
        fastcompmgr-git
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
        volctl
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

# Create or refresh the SDDM drop-in file used for autologin.
configure_sddm_autologin() {
    local target_dir="/etc/sddm.conf.d"
    local target_file="${target_dir}/kde_settings.conf"
    local tmp_file
    local target_user="${SUDO_USER:-$USER}"
    USER=${target_user}


    sudo mkdir -p "${target_dir}"

    tmp_file="$(mktemp)"
    cat > "${tmp_file}" <<EOF
[Autologin]
Relogin=false
Session=ohmychadwm
User=${USER}

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=arcolinux-simplicity
CursorTheme=Bibata-Modern-Ice
Font=Noto Sans,10,-1,0,50,0,0,0,0,0

[Users]
MaximumUid=60513
MinimumUid=1000
EOF

    sudo mv "${tmp_file}" "${target_file}"

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

_install_chadwm=false
_install_ohmychadwm=false
[[ -f "/tmp/install-chadwm" ]] && _install_chadwm=true
[[ -f "/tmp/install-ohmychadwm" ]] && _install_ohmychadwm=true

if "$_install_chadwm" || "$_install_ohmychadwm"; then
    install_core_packages
    install_virtualbox_guest_utils_if_needed
fi

# Install Chadwm
if "$_install_chadwm"; then
    log_section "Let us install Chadwm"
    install_chadwm_package
    configure_sddm_autologin
fi

# Install Ohmychadwm
if "$_install_ohmychadwm"; then
    log_section "Let us install Ohmychadwm"
    install_ohmychadwm_package
    configure_sddm_autologin
fi

log_subsection "$(script_name) done"
