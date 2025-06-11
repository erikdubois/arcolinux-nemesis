#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
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
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

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

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "#######################################################################################"
        echo "################## The package "$1" is already installed"
        echo "#######################################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "#######################################################################################"
        echo "##################  Installing package "  $1
        echo "#######################################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}

func_install_chadwm() {

    echo
    tput setaf 2
    echo "########################################################################"
    echo "################### Install chadwm"
    echo "########################################################################"
    tput sgr0
    echo

    list=(
    alacritty
    archlinux-logout-git
    edu-chadwm-git
    edu-xfce-git
    autorandr
    dash
    dmenu
    eww
    feh
    gcc
    gvfs
    lolcat
    lxappearance-gtk3
    make
    picom-git
    polkit-gnome
    rofi
    sxhkd
    thunar
    thunar-archive-plugin
    thunar-volman
    ttf-hack
    ttf-font-awesome
    ttf-jetbrains-mono-nerd
    ttf-meslo-nerd-font-powerlevel10k
    volumeicon
    xfce4-notifyd
    xfce4-power-manager
    xfce4-screenshooter
    xfce4-settings
    xfce4-taskmanager
    xfce4-terminal
    xorg-xsetroot
    )

    count=0

    for name in "${list[@]}" ; do
        count=$[count+1]
        tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
        func_install $name
    done
}

if [[ -f /etc/dev-rel ]]; then
    echo
    tput setaf 2
    echo "########################################################################"
    echo "############## You are running this nemesis script on an ArcoLinux system"
    echo "############## In order to avoid package conflicts you should first run"
    echo "############## 100-remove-software.sh to remove ArcoLinux packages."
    echo "############## The ArcoLinux packages need to be replaced with the edu-packages"
    echo "############## from the nemesis_repo that should already be declared in"
    echo "############## your /etc/pacman.conf"
    echo "########################################################################"
    sleep 2
    tput sgr0
    echo
fi

remove_if_installed arcolinux-rofi-git
remove_if_installed arcolinux-rofi-themes-git
remove_if_installed arcolinux-chadwm-git
remove_if_installed arconet-xfce
remove_if_installed lxappearance

if [ -f /tmp/install-chadwm ] || [[ "$(basename "$0")" == "600-chadwm.sh" ]]; then

    echo
    tput setaf 2
    echo "########################################################################"
    echo "################### Let us install Chadwm"
    echo "########################################################################"
    tput sgr0
    echo

    func_install_chadwm
    
    if systemd-detect-virt | grep -q "oracle"; then
        sudo add-virtualbox-guest-utils
    fi

    if [ ! -f /usr/local/bin/fix-sddm-conf ]; then

        # fix-sddm-conf - run this if script is not available

        # URL of the file to download
        URL="https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/refs/heads/master/Personal/settings/sddm/kde_settings.conf"

        # Target directory and filename
        TARGET_DIR="/etc/sddm.conf.d"
        TARGET_FILE="$TARGET_DIR/kde_settings.conf"

        # Create the directory if it doesn't exist
        sudo mkdir -p "$TARGET_DIR"

        # Download the file to a temporary location
        TMP_FILE=$(mktemp)
        curl -fsSL "$URL" -o "$TMP_FILE"

        # Check if download succeeded
        if [[ $? -ne 0 ]]; then
          echo "Error: Failed to download file from $URL"
          exit 1
        fi

        # Replace or insert the User field
        if grep -q "^User=" "$TMP_FILE"; then
          sed -i "s/^User=.*/User=$USER/" "$TMP_FILE"
        else
          echo -e "\nUser=$USER" >> "$TMP_FILE"
        fi

        # Move the modified file to the target location
        sudo mv "$TMP_FILE" "$TARGET_FILE"

        echo
        tput setaf 2
        echo "########################################################################"
        echo "###### SDDM configuration changed and set User=$USER at"
        echo "###### /etc/sddm.conf.d/kde_settings.conf"
        echo "###### Check with 'nsddmk' in a terminal and change the variables when necessary"
        echo "########################################################################"
        tput sgr0
        echo

    else
        fix-sddm-conf

        echo
        tput setaf 2
        echo "########################################################################"
        echo "###### SDDM configuration changed and set User=$USER at"
        echo "###### /etc/sddm.conf.d/kde_settings.conf"
        echo "###### Check with 'nsddmk' in a terminal and change the variables when necessary"
        echo "########################################################################"
        tput sgr0
        echo
    fi
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo