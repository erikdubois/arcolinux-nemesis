#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
#####################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#####################################################################

PROJECT_DIR="$(pwd)"

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
clean_pycache() {
    local found
    found=$(find "${PROJECT_DIR}" -type d -name "__pycache__" 2>/dev/null)

    if [[ -n "${found}" ]]; then
        log_section "Cleaning __pycache__"
        find "${PROJECT_DIR}" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
        log_success "__pycache__ removed"
    fi
}

git_pull() {
    log_section "Git pull"
    git -C "${PROJECT_DIR}" pull || log_warn "Git pull failed — continuing with local state"
}

ensure_git_remote_configured() {
    local remote_url
    remote_url="$(git -C "${PROJECT_DIR}" remote get-url origin 2>/dev/null || true)"
    if [[ "${remote_url}" != *"github.com"* ]]; then
        log_section "Git remote not configured — running setup.sh first"
        bash "${PROJECT_DIR}/setup.sh"
    fi
}

git_commit_and_push() {
    local branch

    log_section "Git add / commit / push"
    git -C "${PROJECT_DIR}" add --all .

    if [[ -z "$(git -C "${PROJECT_DIR}" status --porcelain)" ]]; then
        log_info "Nothing to commit — working tree clean"
    else
        git -C "${PROJECT_DIR}" commit -m "update" || log_error "Git commit failed"
    fi

    branch="$(git -C "${PROJECT_DIR}" rev-parse --abbrev-ref HEAD)"

    if ! git -C "${PROJECT_DIR}" push -u origin "${branch}"; then
        log_warn "Push rejected — rebasing on remote changes and retrying"
        git -C "${PROJECT_DIR}" pull --rebase origin "${branch}" || { log_error "Rebase failed — resolve conflicts manually"; return 1; }
        git -C "${PROJECT_DIR}" push -u origin "${branch}" || log_error "Git push failed after rebase"
    fi
}

#####################################################################
# Main
#####################################################################
main() {
    ensure_git_remote_configured
    git_pull
    clean_pycache

    if [[ -f "${PROJECT_DIR}/chaotic.sh" ]]; then
        log_section "Running chaotic.sh"
        bash "${PROJECT_DIR}/chaotic.sh"
    fi

    if [[ -f "${PROJECT_DIR}/repo.sh" ]]; then
        log_section "Running repo.sh"
        bash "${PROJECT_DIR}/repo.sh"
    fi

    git_commit_and_push

    log_success "$(basename "$0") done"
}

main "$@"
