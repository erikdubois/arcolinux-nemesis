#!/usr/bin/env bash
set -euo pipefail

RESET=$(tput sgr0)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)

separator() { printf '%s\n' "────────────────────────────────────────"; }
header()    { separator; printf '%s%s%s\n' "$CYAN"   "$1" "$RESET"; separator; }
success()   { printf '%s%s%s\n' "$GREEN"  "$1" "$RESET"; }
info()      { printf '%s%s%s\n' "$CYAN"   "$1" "$RESET"; }
warn()      { printf '%s%s%s\n' "$YELLOW" "$1" "$RESET"; }
error()     { printf '%s%s%s\n' "$RED"    "$1" "$RESET"; exit 1; }

PACMAN_CONF="/etc/pacman.conf"
BACKUP="/etc/pacman.conf.nemesis"
REPO_ENTRY="[nemesis_repo]"
REPO_BLOCK="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch"

header "Checking for root"
[[ $EUID -ne 0 ]] && error "Run this script as root or with sudo"
success "Running as root"

header "Backing up pacman.conf"
cp "$PACMAN_CONF" "$BACKUP"
success "Backup saved to $BACKUP"

header "Adding nemesis_repo"
if grep -qF "$REPO_ENTRY" "$PACMAN_CONF"; then
    warn "nemesis_repo already present in $PACMAN_CONF — skipping"
else
    printf '%s\n' "$REPO_BLOCK" >> "$PACMAN_CONF"
    success "nemesis_repo added"
fi

header "Syncing package databases"
pacman -Sy
success "Done"
