#!/bin/bash
#set -e
###############################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################

function_remove() {
  if pacman -Qi $1 &> /dev/null; then
  		tput setaf 1
  		echo "###############################################################################"
  		echo "################## "$1" is installed and will be removed now."
      echo "###############################################################################"
      echo
      tput sgr0
      sudo pacman -Rs $1 --noconfirm
  else
    tput setaf 2
    echo "###############################################################################"
    echo "################## "$1" was not present or already removed."
    echo "###############################################################################"
    echo
    tput sgr0
  fi
}

function_remove_dd() {
  if pacman -Qi $1 &> /dev/null; then
  		tput setaf 1
  		echo "###############################################################################"
  		echo "################## "$1" is installed and will be removed now."
      echo "###############################################################################"
      echo
      tput sgr0
      sudo pacman -Rdd $1 --noconfirm
  else
    tput setaf 2
    echo "###############################################################################"
    echo "################## "$1" was already removed."
    echo "###############################################################################"
    echo
    tput sgr0
  fi
}

echo
echo "###############################################################################"
echo "SPECIALITIES"
echo "###############################################################################"
echo
echo "None"
echo
echo "###############################################################################"
echo "REMOVALS"
echo "###############################################################################"
echo
echo "None"
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "###############################################################################"
echo "We have installed hw-probe and edid-decode-git"
echo "###############################################################################"
echo
sudo pacman -S --noconfirm --needed hw-probe
sudo pacman -S --noconfirm --needed edid-decode-git
echo
echo "###############################################################################"
echo "We have installed appstream for the fix of pamac-aur not showing icons"
echo "###############################################################################"
echo
sudo pacman -S --noconfirm --needed appstream
echo
echo "###############################################################################"
echo "WE WILL NO LONGER USE RELEASE NUMBERS IN /ETC/LSB-RELEASE"
echo "ARCOLINUX GOES ROLLING"
echo "Use the alias iso to know which iso you used to install ArcoLinux"
echo "###############################################################################"
echo "https://arcolinuxforum.com/viewtopic.php?f=79&t=2122"
echo "###############################################################################"
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
