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
echo "###############################################################################"
echo "Removing sublime-text-dev and replacing later with sublime-text-4"
echo "###############################################################################"
echo
function_remove sublime-text-dev
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "###############################################################################"
echo "We have added alacritty and created a configuration pacakage for it"
echo "###############################################################################"
echo
sudo pacman -S --noconfirm --needed alacritty arcolinux-alacritty-git
sudo pacman -S --noconfirm --needed sublime-text-4
echo
echo "###############################################################################"
echo "WE WILL NO LONGER USE RELEASE NUMBERS IN /ETC/LSB-RELEASE"
echo "ARCOLINUX GOES ROLLING"
echo "Use the alias iso to know which iso you have used to install ArcoLinux"
echo "This number will never change"
echo "###############################################################################"
echo "https://arcolinuxforum.com/viewtopic.php?f=79&t=2122"
echo "###############################################################################"
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
