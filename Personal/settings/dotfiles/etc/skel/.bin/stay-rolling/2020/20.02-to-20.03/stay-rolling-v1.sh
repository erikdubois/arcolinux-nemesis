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


echo "###############################################################################"
echo "SPECIALITIES"
echo "###############################################################################"
echo
echo "None"
#sudo pacman -S --noconfirm --needed
echo
echo "###############################################################################"
echo "REMOVALS"
echo "###############################################################################"
echo "We have removed these packages from the iso :"
echo
echo "None"
#function_remove ...
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
#echo "None"
echo "Making sure you have ArcoLinux Welcome App and ArcoLinux Tweak Tool"
sudo pacman -S --noconfirm --needed dex
sudo pacman -S --noconfirm --needed arcolinux-welcome-app-git
sudo pacman -S --noconfirm --needed arcolinux-tweak-tool-git
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
echo "###############################################################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "###############################################################################"
echo
sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v20.3.4/' /etc/lsb-release

echo "###############################################################################"
echo "###                LSB-RELEASE NUMBER UPDATED               ####"
echo "###############################################################################"
