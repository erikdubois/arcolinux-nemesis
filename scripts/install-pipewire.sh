#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Install PipeWire audio stack
# - Replace PulseAudio
# - Enable Bluetooth audio support
##################################################################################################################################

main() {

    log_section "Installing PipeWire audio stack"

    ############################################################################################################
    # Remove conflicting packages
    ############################################################################################################

    remove_matching_packages \
        gnome-bluetooth \
        blueberry \
        pipewire-media-session

    sudo pacman -Rdd --noconfirm jack2 pulseaudio pulseaudio-alsa pulseaudio-bluetooth || true

    ############################################################################################################
    # Install PipeWire stack
    ############################################################################################################

    install_packages \
        pipewire \
        lib32-pipewire \
        wireplumber \
        pipewire-alsa \
        pipewire-jack \
        lib32-pipewire-jack \
        pipewire-zeroconf \
        pipewire-pulse

    ############################################################################################################
    # Restore bluetooth tools
    ############################################################################################################

    install_packages gnome-bluetooth blueberry
    enable_service bluetooth.service

    log_success "PipeWire installation completed"
    log_warn "Reboot recommended"
}

main "$@"