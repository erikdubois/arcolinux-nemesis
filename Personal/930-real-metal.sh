#!/bin/bash
set -uo pipefail  # Do not use set -e, we want to continue on error
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
# Github    : https://github.com/buildra
# SF        : https://sourceforge.net/projects/kiro/files/
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue

#end colors
#tput sgr0
##################################################################################################################################

# Get current directory of the script
installed_dir="$(dirname "$(readlink -f "$0")")"

##################################################################################################################################

# Debug mode switch
export DEBUG=false

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename "$0")"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##############################################################################################################

install_packages() {
    if [ "$#" -eq 0 ]; then
        echo "No packages provided to install."
        return 1
    fi

    for pkg in "$@"; do
        echo
        echo "Installing package: $pkg"
        sudo pacman -S --noconfirm --needed "$pkg"
    done
}

##################################################################################################################################

remove_if_installed() {
    for pattern in "$@"; do
        # Find all installed packages that match the pattern (exact + variants)
        matches=$(pacman -Qq | grep "^${pattern}$\|^${pattern}-")
        
        if [ -n "$matches" ]; then
            for pkg in $matches; do
                echo "Removing package: $pkg"
                sudo pacman -R --noconfirm "$pkg"
            done
        else
            echo "No packages matching '$pattern' are installed."
        fi
    done
}

##############################################################################################################

result=$(systemd-detect-virt)

echo
echo "result = "$result
echo
tput setaf 3
echo "########################################################################"
echo "################### VirtualBox check - Copy/paste VB template or not"
echo "########################################################################"
tput sgr0
echo

if [ $result = "none" ];then

    [ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
    sudo cp -rf settings/virtualbox-template/* ~/VirtualBox\ VMs/
    cd ~/VirtualBox\ VMs/
    tar -xzf template.tar.gz
    rm -f template.tar.gz   

else

    echo
    tput setaf 3
    echo "########################################################################"
    echo "### You are on a virtual machine - skipping VirtualBox"
    echo "### Template not copied over"
    echo "### We will set your screen resolution with xrandr"
    echo "########################################################################"
    tput sgr0
    echo

    # Find the connected VirtualBox display
    OUTPUT=$(xrandr | grep " connected" | awk '{print $1}')

    # Fallback check
    if [ -z "$OUTPUT" ]; then
        echo "No connected display found."
        exit 1
    fi

    # Apply desired resolution and position
    xrandr --output "$OUTPUT" --primary --mode 1920x1080 --pos 0x0 --rotate normal

    echo "Display settings applied to output: $OUTPUT"

    fi

tput setaf 3
echo "########################################################################"
echo "################### Removal of virtual machine software"
echo "########################################################################"
tput sgr0
echo

# Proceed only if running on real hardware
if [[ "$result" == "none" ]]; then
    echo "Running on real hardware. Proceeding with cleanup..."

    # Disable and stop qemu-guest-agent.service if present
    if systemctl list-units --full --all | grep -q 'qemu-guest-agent.service'; then
        echo "Disabling qemu-guest-agent.service..."
        sudo systemctl stop qemu-guest-agent.service
        sudo systemctl disable qemu-guest-agent.service
    fi

    # Disable and stop vboxservice.service if present
    if systemctl list-units --full --all | grep -q 'vboxservice.service'; then
        echo "Disabling vboxservice.service..."
        sudo systemctl stop vboxservice.service
        sudo systemctl disable vboxservice.service
    fi

    # Remove QEMU packages
    remove_if_installed qemu-guest-agent
    # Remove VirtualBox packages
    remove_if_installed virtualbox-guest-utils

else
    echo "Virtual machine detected ($result). No action taken."
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo