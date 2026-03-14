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
# - Install and configure zram swap using systemd-zram-generator
##################################################################################################################################

main() {

    log_section "Installing ZRAM"

    install_packages zram-generator

    log_subsection "Creating zram configuration"

    sudo tee /etc/systemd/zram-generator.conf >/dev/null <<EOF
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
swap-priority = 100
fs-type = swap
EOF

    log_subsection "Reloading systemd and starting zram"

    sudo systemctl daemon-reload
    sudo systemctl start /dev/zram0 || true

    log_success "ZRAM enabled"
    log_info "Check with: swapon --show or zramctl"
}

main "$@"