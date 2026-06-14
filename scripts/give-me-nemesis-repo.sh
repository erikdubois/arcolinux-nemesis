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
BACKUP="/etc/pacman.conf-nemesis"
REPO_ENTRY="[nemesis_repo]"
REPO_BLOCK="
[nemesis_repo]
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
success "Databases synced"

# nemesis_repo inherits the global SigLevel = Required, so the Kiro key must be
# trusted BEFORE any install — the keyring is itself a signed nemesis package
# (chicken-and-egg), and a remote `pacman -U` URL is governed by
# RemoteFileSigLevel (defaults to Required), so it can't bootstrap an untrusted
# key either. Fetch the master key from a public keyserver and locally sign it
# (the key lives on keyserver.ubuntu.com and keys.openpgp.org), then install the
# two packages nemesis_repo needs: kiro-keyring + kiro-mirrorlist.
header "Trusting the Kiro signing key and installing keyring + mirrorlist"
if pacman -Qq kiro-keyring &>/dev/null && pacman -Qq kiro-mirrorlist &>/dev/null; then
    success "kiro-keyring and kiro-mirrorlist already installed — nemesis_repo trusted"
else
    KEY_ID="149ABD0C3A0563EE"
    if ! pacman-key --recv-keys "$KEY_ID" --keyserver keyserver.ubuntu.com; then
        warn "keyserver.ubuntu.com failed — trying keys.openpgp.org"
        pacman-key --recv-keys "$KEY_ID" --keyserver keys.openpgp.org \
            || error "Could not receive the Kiro signing key"
    fi
    pacman-key --lsign-key "$KEY_ID"
    pacman -Sy --needed --noconfirm kiro-keyring kiro-mirrorlist
    success "kiro-keyring and kiro-mirrorlist installed — nemesis_repo ready"
fi
