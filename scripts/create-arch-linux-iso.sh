#!/bin/bash

##################################################################################################
# Description: This script asks the user if they want to create an Arch Linux ISO.
# It installs 'archiso' if needed and builds the ISO from the default releng profile.
# The ISO is first built in /tmp and then moved to /home/$USER/
##################################################################################################

set -e  # Exit on error

echo "Do you want to create an Arch Linux ISO? (yes/no)"
read -r answer

if [[ "$answer" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
    echo "Installing 'archiso' if not already installed..."
    sudo pacman -S --noconfirm --needed archiso

    echo "Creating the Arch Linux ISO in /tmp..."
    work_dir="/tmp/archiso-work"
    out_dir="/tmp/archiso-out"

    sudo mkarchiso -v -w "$work_dir" -o "$out_dir" /usr/share/archiso/configs/releng/

    iso_file=$(find "$out_dir" -name "*.iso" | head -n 1)

    if [[ -f "$iso_file" ]]; then
        echo "Moving ISO to /home/$USER/..."
        cp "$iso_file" "/home/$USER/"
        echo "ISO has been moved to /home/$USER/."
    else
        echo "ISO not found in $out_dir."
    fi
else
    echo "Aborted. No ISO created."
fi
