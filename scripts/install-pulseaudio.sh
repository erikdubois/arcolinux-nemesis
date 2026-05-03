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
# - Switch from PipeWire to PulseAudio audio stack
# - Remove all PipeWire packages and services
# - Install PulseAudio audio stack
# - Keep Bluetooth audio support enabled
##################################################################################################################################

audio_summary() {
    log_section "Current audio state"

    local server
    server=$(pactl info 2>/dev/null | awk '/Server Name/ {print $NF}') || server="unknown (pactl failed)"
    log_info "Active server : $server"

    for pkg in pulseaudio pipewire pipewire-pulse wireplumber; do
        local ver
        ver=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}') || ver="not installed"
        log_info "  $pkg : $ver"
    done
}

main() {

    audio_summary

    log_section "Switching to PulseAudio audio stack"

    ############################################################################################################
    # Stop and disable PipeWire services
    ############################################################################################################

    systemctl --user disable pipewire-pulse.service 2>/dev/null || true
    systemctl --user stop pipewire-pulse.service 2>/dev/null || true
    systemctl --user disable pipewire.service 2>/dev/null || true
    systemctl --user stop pipewire.service 2>/dev/null || true

    log_info "Stopped PipeWire services"

    ############################################################################################################
    # Clean up stale PipeWire ALSA config
    ############################################################################################################

    if [[ -f /etc/alsa/conf.d/99-pipewire-default.conf ]]; then
        sudo rm /etc/alsa/conf.d/99-pipewire-default.conf
        log_info "Removed stale PipeWire ALSA config"
    fi

    ############################################################################################################
    # Remove conflicting audio packages
    ############################################################################################################

    remove_matching_packages pipewire-media-session

    remove_matching_packages_deps_dd \
        pipewire \
        lib32-pipewire \
        libpipewire \
        pipewire-alsa \
        pipewire-audio \
        pipewire-jack \
        lib32-pipewire-jack \
        pipewire-session-manager \
        pipewire-zeroconf \
        pipewire-pulse \
        wireplumber

    ############################################################################################################
    # Force remove pipewire-pulse if still present (conflicts with pulseaudio)
    ############################################################################################################

    if pkg_installed pipewire-pulse; then
        log_info "Force removing pipewire-pulse..."
        sudo pacman -Rdd --noconfirm pipewire-pulse 2>/dev/null || true
    fi

    ############################################################################################################
    # Install PulseAudio stack
    ############################################################################################################

    install_packages \
        pulseaudio \
        pulseaudio-alsa \
        pulseaudio-bluetooth \
        jack2 \
        volctl

    ############################################################################################################
    # Enable Bluetooth service
    ############################################################################################################

    enable_now_service bluetooth.service

    log_success "PulseAudio installation completed"
    log_warn "Reboot recommended"
}

main "$@"