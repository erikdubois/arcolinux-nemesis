#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

function_remove() {
  if pacman -Qi $1 &> /dev/null; then
  		tput setaf 1
  		echo "################################################################"
  		echo "################## "$1" is installed and will be removed now."
      echo "################################################################"
      echo
      tput sgr0
      sudo pacman -Rs $1 --noconfirm
  else
    tput setaf 2
    echo "################################################################"
    echo "################## "$1" was not present or already removed."
    echo "################################################################"
    echo
    tput sgr0
  fi
}

function_remove_dd() {
  if pacman -Qi $1 &> /dev/null; then
  		tput setaf 1
  		echo "################################################################"
  		echo "################## "$1" is installed and will be removed now."
      echo "################################################################"
      echo
      tput sgr0
      sudo pacman -Rdd $1 --noconfirm
  else
    tput setaf 2
    echo "################################################################"
    echo "################## "$1" was already removed."
    echo "################################################################"
    echo
    tput sgr0
  fi
}


echo "################################################################"
echo "SPECIALITIES"
echo "################################################################"
echo
echo "We have moved to i3-gaps. You decide if you want to switch from i3-gaps-next-git."
echo "November gave us some trouble with codecs - you decide if you want to keep vivaldi-codecs-ffmpeg-extra-bin"
echo "It is working again now"
#sudo pacman -S --noconfirm --needed
echo
echo "################################################################"
echo "REMOVALS"
echo "################################################################"
echo "We have removed these packages from the iso :"
echo
echo "Dependency no longer necessary - package no longer exists"
function_remove python2-xapp
echo
echo "20/12/2019 - Arch Linux message - xorgproto"
function_remove_dd libdmx
function_remove_dd libxxf86dga
function_remove_dd libxxf86misc
echo
echo "20/12/2019 - Arch Linux message Xorg cleanup"
function_remove_dd xf86-input-keyboard
function_remove_dd xf86-input-mouse
echo
echo "Arch Linux package name changes"
function_remove pyqt5-common
function_remove python-sip-pyqt5
echo
echo "################################################################"
echo "INSTALLATIONS"
echo "################################################################"
echo "We have installed these packages on the iso :"
echo
echo "correction for the version number - not a downgrade"
sudo pacman -S arcolinux-lightdm-gtk-greeter --noconfirm
echo "lshw is an interesting tool analyzing app"
sudo pacman -S lshw --noconfirm --needed
echo "Installation of cron service for reflector"
sudo pacman -S cronie --noconfirm --needed
sudo pacman -S arcolinux-cron-git --noconfirm
echo "New theme for oblogout"
sudo pacman -S arcolinux-oblogout --noconfirm
echo "hblock"
sudo pacman -S arcolinux-hblock-git --noconfirm --needed
echo
echo "################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "################################################################"
echo
echo "################################################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "################################################################"
echo
sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v19.12.17/' /etc/lsb-release

echo "################################################################"
echo "###                LSB-RELEASE NUMBER UPDATED               ####"
echo "################################################################"
