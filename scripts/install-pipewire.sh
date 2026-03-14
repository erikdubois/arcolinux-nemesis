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
# - Install PipeWire audio stack
# - Replace PulseAudio
# - Keep Bluetooth audio support enabled
##################################################################################################################################

main() {

    log_section "Installing PipeWire audio stack"

    ############################################################################################################
    # Remove conflicting audio packages
    ############################################################################################################

    remove_matching_packages pipewire-media-session

    remove_matching_packages_deps_dd \
        jack2 \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth

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
    # Enable Bluetooth service
    ############################################################################################################

    enable_service bluetooth.service

    log_success "PipeWire installation completed"
    log_warn "Reboot recommended"
}

main "$@"