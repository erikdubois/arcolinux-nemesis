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
# - Install PipeWire audio stack (modern Arch default)
# - Remove PulseAudio audio packages
# - Enable PipeWire's PulseAudio emulation for backward compatibility (pavucontrol, etc.)
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

    log_section "Installing PipeWire audio stack"

    ############################################################################################################
    # Force remove PulseAudio and any packages that depend on it
    ############################################################################################################

    if pkg_installed pulseaudio; then
        log_info "Removing packages that depend on PulseAudio..."
        dependents=$(pacman -Qi pulseaudio 2>/dev/null | awk '/^Required By/ {$1=$2=""; print $0}' | tr ' ' '\n' | grep -v '^$' | grep -v '^None$')
        for dep in $dependents; do
            if pkg_installed "$dep"; then
                log_info "Removing dependent: $dep"
                sudo pacman -Rdd --noconfirm "$dep" 2>/dev/null || true
            fi
        done

        log_info "Removing PulseAudio..."
        sudo pacman -Rdd --noconfirm pulseaudio 2>/dev/null || true
    fi

    ############################################################################################################
    # Clean up stale PipeWire ALSA config
    ############################################################################################################

    if [[ -f /etc/alsa/conf.d/99-pipewire-default.conf ]]; then
        sudo rm /etc/alsa/conf.d/99-pipewire-default.conf
        log_info "Removed stale PipeWire ALSA config"
    fi

    ############################################################################################################
    # Install PipeWire stack core packages first
    ############################################################################################################

    install_packages \
        pipewire \
        pipewire-alsa \
        pipewire-audio \
        pipewire-session-manager \
        wireplumber \
        volctl

    ############################################################################################################
    # Install PulseAudio emulation
    ############################################################################################################

    install_packages pipewire-pulse

    systemctl --user enable pipewire-pulse.service
    systemctl --user start pipewire-pulse.service

    log_info "PulseAudio emulation enabled (allows pavucontrol and PulseAudio apps to work)"

    ############################################################################################################
    # Enable Bluetooth service
    ############################################################################################################

    enable_now_service bluetooth.service

    log_success "PipeWire installation completed"
    log_warn "Reboot recommended"
}

main "$@"
