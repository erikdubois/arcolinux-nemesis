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
# - Install Qt 6 development environment
##################################################################################################################################

main() {
    log_section "Installing Qt 6 development environment"

    install_packages \
        qt6-base \
        qt6-doc \
        qt6-tools \
        qtcreator

    log_success "Qt 6 development environment installed"
}

main "$@"