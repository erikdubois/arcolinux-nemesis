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

install_bluetooth_packages() {

    log_section "Installing bluetooth packages"

    install_packages \
        bluez \
        bluez-libs \
        bluez-utils

    if [[ ! -f /usr/share/xsessions/plasma.desktop ]]; then
        install_packages blueberry
    fi

    if ! pacman -Qi pipewire-pulse &>/dev/null; then
        install_packages pulseaudio-bluetooth
    fi
}

configure_bluetooth() {

    log_section "Configuring bluetooth"

    enable_now_service bluetooth.service

    sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf
}

configure_pulseaudio_modules() {

    if [[ -f /etc/pulse/system.pa ]]; then

        log_section "Configuring PulseAudio bluetooth modules"

        grep -q "module-switch-on-connect" /etc/pulse/system.pa || \
            echo "load-module module-switch-on-connect" | sudo tee -a /etc/pulse/system.pa >/dev/null

        grep -q "module-bluetooth-policy" /etc/pulse/system.pa || \
            echo "load-module module-bluetooth-policy" | sudo tee -a /etc/pulse/system.pa >/dev/null

        grep -q "module-bluetooth-discover" /etc/pulse/system.pa || \
            echo "load-module module-bluetooth-discover" | sudo tee -a /etc/pulse/system.pa >/dev/null
    fi
}

install_bluetooth_packages
configure_bluetooth
configure_pulseaudio_modules

log_subsection "$(script_name) done"