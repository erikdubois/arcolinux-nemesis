#!/usr/bin/env bash

##################################################################################################################
# Check systemd-boot Configuration
##################################################################################################################

echo "=== systemd-boot Boot Configuration Check ==="
echo

# Check both paths
for path in /boot/efi/loader /boot/loader; do
    if [[ -d "$path" ]]; then
        echo "Found loader at: $path"
        echo

        echo "--- loader.conf ---"
        if [[ -f "$path/loader.conf" ]]; then
            cat "$path/loader.conf"
        else
            echo "File not found: $path/loader.conf"
        fi
        echo

        echo "--- Available kernel entries ---"
        if [[ -d "$path/entries" ]]; then
            ls -la "$path/entries/"
            echo
            echo "--- Entry filenames ---"
            for entry in "$path/entries"/*.conf; do
                echo "  - $(basename "$entry" .conf)"
            done
        else
            echo "No entries directory found"
        fi
        echo
    fi
done

echo "--- EFI variables (if available) ---"
if command -v efibootmgr >/dev/null 2>&1; then
    efibootmgr
else
    echo "efibootmgr not installed"
fi

echo
echo "--- Last boot ---"
if [[ -f /proc/cmdline ]]; then
    echo "Current kernel command line:"
    cat /proc/cmdline
fi

echo
uname -a
