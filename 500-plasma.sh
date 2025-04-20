#!/bin/bash
#set -e
##################################################################################################################################
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

# when on Plasma

if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then

  tput setaf 2
  echo "This will not install Plasma"
  echo "It detects whether Plasma is installed like when on ArcoPlasma"
  tput sgr0
  echo

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### Plasma Software to install"
  echo "########################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed edu-plasma-keybindings-git
  sudo pacman -S --noconfirm --needed edu-plasma-servicemenus-git
  sudo pacman -S --noconfirm --needed obs-studio
  sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
  sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo