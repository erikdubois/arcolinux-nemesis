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

hyprland="/usr/share/wayland-sessions/hyprland.desktop"
wayfire="/usr/share/wayland-sessions/wayfire.desktop"
sway="/usr/share/wayland-sessions/sway.desktop"

# common to all desktops

if [[ -f $hyprland || -f $wayfire || -f $sway ]]; then

  echo
  echo "Adding thunar - gitahead setting - righ mouse click"
  echo
  sudo cp -arf $installed_dir/Personal/settings/wayland/thunar/uca.xml ~/.config/Thunar/
  echo

  echo
  echo "Installing extra packages"
  echo

  sudo pacman -S --noconfirm --needed arcolinux-wayland-app-hooks-git
  sudo pacman -S --noconfirm --needed obs-studio
  sudo pacman -S --noconfirm --needed wlrobs
  sudo pacman -S --noconfirm --needed spotify-wayland

fi

# each desktop is unique

if [ -f /usr/share/wayland-sessions/sway.desktop ]; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "################### We are on Sway"
  echo "################################################################"
  tput sgr0
  echo
  
  give-me-azerty-be-sway

fi

if [ -f /usr/share/wayland-sessions/wayfire.desktop ]; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "################### We are on Wayfire"
  echo "################################################################"
  tput sgr0
  echo

  give-me-azerty-be-wayfire

fi

if [ -f /usr/share/wayland-sessions/hyprland.desktop ]; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "################### We are on Hyprland"
  echo "################################################################"
  tput sgr0
  echo

  give-me-azerty-be-hyprland
  
fi