#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
#####################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   - Builds dist/tailwind.css from tailwind.input.css using the local
#     tailwindcss CLI (installed via npm in this folder). Minified.
#   - Scans the site's HTML pages for utility classes (see the content
#     array in tailwind.config.js).
#
#   Why: GitHub Pages serves this /docs folder directly with no build
#   step, so the built dist/tailwind.css must be committed. Run this
#   after editing any page, then commit dist/tailwind.css alongside the
#   HTML. Built CSS is ~25 KB vs ~3 MB of CDN JS and ships no warning.
#
#####################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#####################################################################
# Colors
#####################################################################
if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    CYAN="$(tput setaf 6)"
    RESET="$(tput sgr0)"
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

#####################################################################
# Logging
#####################################################################
log_section() {
    echo
    echo "${GREEN}############################################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################################${RESET}"
    echo
}

log_info() {
    echo
    echo "${BLUE}############################################################################${RESET}"
    echo "$1"
    echo "${BLUE}############################################################################${RESET}"
    echo
}

log_warn() {
    echo
    echo "${YELLOW}############################################################################${RESET}"
    echo "$1"
    echo "${YELLOW}############################################################################${RESET}"
    echo
}

log_error() {
    echo
    echo "${RED}############################################################################${RESET}"
    echo "$1"
    echo "${RED}############################################################################${RESET}"
    echo
}

log_success() {
    echo
    echo "${GREEN}############################################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################################${RESET}"
    echo
}

#####################################################################
# Error handling
#####################################################################
on_error() {
    local lineno="$1"
    local cmd="$2"
    echo
    echo "${RED}ERROR on line ${lineno}: ${cmd}${RESET}"
    echo
    sleep 10
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

#####################################################################
# Functions
#####################################################################
require_tailwind() {
    if [[ ! -x "${SCRIPT_DIR}/node_modules/.bin/tailwindcss" ]]; then
        log_warn "tailwindcss CLI not found locally — installing now"
        (cd "${SCRIPT_DIR}" && npm install --save-dev tailwindcss@3)
    fi
}

build_css() {
    local input="${SCRIPT_DIR}/tailwind.input.css"
    local output="${SCRIPT_DIR}/dist/tailwind.css"

    mkdir -p "${SCRIPT_DIR}/dist"

    log_section "Building Tailwind CSS"
    "${SCRIPT_DIR}/node_modules/.bin/tailwindcss" \
        -i "${input}" \
        -o "${output}" \
        --minify

    local bytes
    bytes=$(stat -c%s "${output}")
    log_info "Built ${output} — $(numfmt --to=iec "${bytes}")"
}

#####################################################################
# Main
#####################################################################
main() {
    require_tailwind
    build_css
    log_success "$(basename "$0") done"
}

main "$@"
