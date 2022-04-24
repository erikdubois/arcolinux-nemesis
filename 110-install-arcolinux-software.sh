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

echo
tput setaf 2
echo "################################################################"
echo "################### ArcoLinux Software to install"
echo "################################################################"
tput sgr0
echo

if grep -q arcolinux_repo /etc/pacman.conf; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################ ArcoLinux repos are already in /etc/pacman.conf"
  echo "################################################################"
  tput sgr0
  echo
  else
  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Getting the keys and mirrors for ArcoLinux"
  echo "################################################################"
  tput sgr0
  echo
  sh arch/get-the-keys-and-repos.sh
  sudo pacman -Sy
fi

sudo pacman -S --noconfirm --needed arcolinux-arc-themes-2021-sky-git
sudo pacman -S --noconfirm --needed arcolinux-hblock-git
sudo pacman -S --noconfirm --needed arcolinux-logout-git
sudo pacman -S --noconfirm --needed arcolinux-tweak-tool-git
sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git

###############################################################################

if [ ! -f /usr/local/bin/get-nemesis-on-arcolinux ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Correct pamac"
  echo "################################################################"
  tput sgr0
  echo

  [ -d /etc/pacman.d/hooks ] || sudo mkdir -p /etc/pacman.d/hooks

  sudo pacman -S --noconfirm --needed appstream

  sudo cp $installed_dir/Personal/settings/pacman-hook/archlinux-appstream-data-fix /usr/local/bin/archlinux-appstream-data-fix
  sudo cp $installed_dir/Personal/settings/pacman-hook/archlinux-appstream-data.hook /etc/pacman.d/hooks/archlinux-appstream-data.hook

  sudo pacman -S --noconfirm --needed arcolinux-pamac-all
  sudo pacman -S --noconfirm archlinux-appstream-data

fi

# when on Plasma

if [ -f /usr/bin/startplasma-x11 ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma related applications"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
  sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
  sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git
fi

echo
tput setaf 2
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo



