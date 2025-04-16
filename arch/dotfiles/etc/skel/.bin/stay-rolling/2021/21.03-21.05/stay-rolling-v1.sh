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
echo "We have added paru and created a configuration pacakage for it"
echo "If you want to keep or remove trizen is up to you"
echo "sudo pacman -R trizen"
echo "to remove it"
echo "###############################################################################"
echo
sudo pacman -S --noconfirm --needed paru-bin arcolinux-paru-git
echo
echo "###############################################################################"
echo "We have added ripgrep to search for content within files"
echo "rg speed - to search for the word speed in any of the files"
echo "###############################################################################"
echo
sudo pacman -S --noconfirm --needed ripgrep
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
