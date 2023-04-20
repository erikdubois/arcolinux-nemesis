#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################



  if [ -f /usr/share/wayland-sessions/sway.desktop ]; then
    echo
    tput setaf 2
    echo "################################################################"
    echo "################### We are on Sway"
    echo "################################################################"
    tput sgr0
    echo

    echo
    echo "Removing packages"
    echo

    sudo pacman -R flameshot-git --noconfirm

    echo
    echo "Installing extra packages"
    echo

    sudo pacman -S --noconfirm --needed wf-recorder-git
    sudo pacman -S --noconfirm --needed arcolinux-wayland-app-hooks-git
    sudo pacman -S edu-flameshot-git --noconfirm

    if ! pacman -Qi nvidia-dkms &> /dev/null; then
      sudo pacman -S --noconfirm --needed libva-intel-driver
    fi

  fi

  if [ -f /usr/share/wayland-sessions/hyprland.desktop ]; then
    echo
    tput setaf 2
    echo "################################################################"
    echo "################### We are on Hyprland"
    echo "################################################################"
    tput sgr0
    echo

    echo
    echo "Removing packages"
    echo

    sudo pacman -R flameshot-git --noconfirm

    echo
    echo "Installing extra packages"
    echo

    sudo pacman -S --noconfirm --needed wf-recorder-git
    sudo pacman -S --noconfirm --needed arcolinux-wayland-app-hooks-git
    sudo pacman -S edu-flameshot-git --noconfirm

    if ! pacman -Qi nvidia-dkms &> /dev/null; then
      sudo pacman -S --noconfirm --needed libva-intel-driver
    fi

  fi