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
# - Install PulseAudio audio stack
# - Replace PipeWire audio packages
# - Keep Bluetooth audio support enabled
##################################################################################################################################

main() {

    log_section "Installing PulseAudio audio stack"

    ############################################################################################################
    # Remove conflicting audio packages
    ############################################################################################################

    remove_matching_packages pipewire-media-session

    remove_matching_packages_deps_dd \
        pipewire \
        lib32-pipewire \
        wireplumber \
        pipewire-alsa \
        pipewire-jack \
        lib32-pipewire-jack \
        pipewire-zeroconf \
        pipewire-pulse

    ############################################################################################################
    # Install PulseAudio stack
    ############################################################################################################

    install_packages \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        jack2

    ############################################################################################################
    # Enable Bluetooth service
    ############################################################################################################

    enable_now_service bluetooth.service

    log_success "PulseAudio installation completed"
    log_warn "Reboot recommended"
}

main "$@"