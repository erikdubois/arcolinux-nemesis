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
echo "networkmanager-dispatcher-ntpd"
function_remove networkmanager-dispatcher-ntpd
echo
echo "We have removed this package from the iso :"
echo "kvantum-theme-arc"
function_remove kvantum-theme-arc
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "###############################################################################"
echo "We have installed arcolinux-kvantum-theme-arc-git"
echo "###############################################################################"
sudo pacman -S --noconfirm --needed arcolinux-kvantum-theme-arc-git
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

DESKTOP=/usr/share/xsessions/plasma.desktop
if [ -f "$DESKTOP" ]; then
  tput setaf 1
  echo "###############################################################################"
  echo "We do not recommend arcolinux-kvantum-theme-arc-git on Plasma."
  echo "The script removes the package automatically from your system"
  echo "if the script finds plasma on your computer."
  echo "If you have a system with multiple desktops, it is up to the user"
  echo "to re-install the package or not."
  echo "###############################################################################"
  tput sgr0
  function_remove arcolinux-kvantum-theme-arc-git
  echo
  echo "###############################################################################"
  echo "###                   STAY-ROLLING DONE                     ####"
  echo "###############################################################################"
fi

DESKTOP=/usr/share/xsessions/deepin.desktop
if [ -f "$DESKTOP" ]; then
  tput setaf 1
  echo "###############################################################################"
  echo "We do not recommend arcolinux-kvantum-theme-arc-git on Deepin."
  echo "The script removes the package automatically from your system"
  echo "if the script finds deepin on your computer."
  echo "If you have a system with multiple desktops, it is up to the user"
  echo "to re-install the package or not."
  echo "###############################################################################"
  tput sgr0
  function_remove arcolinux-kvantum-theme-arc-git
  echo
  echo "###############################################################################"
  echo "###                   STAY-ROLLING DONE                     ####"
  echo "###############################################################################"
fi
