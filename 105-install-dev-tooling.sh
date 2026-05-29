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

##################################################################################################################################
# Purpose
# - Install the developer / workflow tooling accreted on Erik's Kiro dev box that core nemesis software did not cover
# - Lens: building and maintaining the Kiro ISO + nemesis_repo, plus the daily content/dev flow
# - Must-have set: ISO/chroot tooling, mirror ranking, gh, sshpass, codespell, fd, inxi, whisper (cpp + python), imagemagick
# - Nice-to-have set: pacman/repo helpers, monitors, terminal QoL, theming + content-pipeline extras (trim to taste)
# Why:
# - These tools drifted onto the dev box one-by-one; bootstrapping a fresh box should pull them in automatically
##################################################################################################################################

# Load shared helper functions
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

# Log current script
log_section "Running $(script_name)"

# Pause when debug mode is enabled
pause_if_debug

# Must-have: core to building/maintaining the Kiro ISO + repo and the daily flow
install_dev_tooling_must_have() {
    install_packages \
        arch-install-scripts \
        reflector \
        github-cli \
        sshpass \
        codespell \
        fd \
        inxi \
        whisper-cpp-git \
        python-openai-whisper \
        imagemagick
}

# Nice-to-have: quality-of-life dev tooling (comment out anything you don't want)
install_dev_tooling_nice_to_have() {
    install_packages \
        pkgfile \
        pacquery \
        arch-rebuild-order \
        nodejs \
        npm \
        ncdu \
        glances \
        tmux \
        sysz \
        tldr \
        ripgrep-all \
        yt-dlp \
        xclip \
        gpick
}

# Main execution
log_section "Installing developer / workflow tooling"

install_dev_tooling_must_have
install_dev_tooling_nice_to_have

# Finished
log_subsection "$(script_name) done"
