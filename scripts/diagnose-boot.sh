#!/usr/bin/env bash

##################################################################################################################
# Detailed Boot Configuration Diagnostic
##################################################################################################################

##################################################################################################################
# Root Check
##################################################################################################################

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    echo "Please use: sudo $0"
    exit 1
fi

echo "=== Detailed Boot Configuration Diagnostic ==="
echo

for path in /boot/efi/loader /boot/loader; do
    if [[ -d "$path" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "LOADER CONFIGURATION: $path"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo

        echo "--- loader.conf (complete) ---"
        cat "$path/loader.conf"
        echo
        echo

        echo "--- KERNEL ENTRIES ---"
        echo
        for entry in "$path/entries"/*.conf; do
            echo "╭─ $(basename "$entry")"
            echo "│"
            while IFS= read -r line; do
                echo "│ $line"
            done < "$entry"
            echo "╰───────────────────────────────"
            echo
        done
        echo
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CURRENT SYSTEM INFO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Currently booted kernel:"
uname -a
echo

echo "Kernel command line:"
cat /proc/cmdline
echo
echo

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "EFI BOOT MANAGER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
if command -v efibootmgr >/dev/null 2>&1; then
    efibootmgr
else
    echo "efibootmgr not installed"
fi
echo

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SYSTEMD-BOOT STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
if command -v bootctl >/dev/null 2>&1; then
    bootctl status
else
    echo "bootctl not installed"
fi
