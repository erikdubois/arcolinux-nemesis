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
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Replace PipeWire audio stack with PulseAudio
# - Restore Bluetooth audio support
##################################################################################################################################

main() {

    log_section "Installing PulseAudio stack"

    ############################################################################################################
    # Remove PipeWire stack
    ############################################################################################################

    sudo pacman -Rdd --noconfirm pipewire-pulse pulse-native-provider pipewire pipewire-jack || true

    remove_matching_packages \
        gnome-bluetooth \
        blueberry \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-media-session \
        pipewire-zeroconf

    ############################################################################################################
    # Install PulseAudio stack
    ############################################################################################################

    install_packages \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        jack2

    ############################################################################################################
    # Restore bluetooth tools
    ############################################################################################################

    install_packages gnome-bluetooth blueberry
    enable_service bluetooth.service

    log_success "PulseAudio installation completed"
    log_warn "Reboot recommended"
}

main "$@"