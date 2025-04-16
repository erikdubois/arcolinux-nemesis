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
echo
echo "###############################################################################"
echo "REMOVALS"
echo "###############################################################################"
#echo "None"
echo "We have removed this package from the iso :"
echo "arcolinux-cron-git - it did an update of mirrors at random during the day"
echo "Update mirrors via welcome app or aliases"
function_remove arcolinux-cron-git
echo "We keep cronie as it is needed for timeshift. You can remove it if you do not"
echo "use timeshift."
echo
echo "We have removed this package from the iso :"
echo "xorg-font-utils - missing AUR package"
function_remove xorg-font-utils
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "None"
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
echo "###############################################################################"
echo "WE WILL NO LONGER USE RELEASE NUMBERS IN /ETC/LSB-RELEASE"
echo "ARCOLINUX GOES ROLLING"
#sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1rolling/' /etc/lsb-release
echo "###############################################################################"
echo "https://arcolinuxforum.com/viewtopic.php?f=79&t=2122"
echo "###############################################################################"
