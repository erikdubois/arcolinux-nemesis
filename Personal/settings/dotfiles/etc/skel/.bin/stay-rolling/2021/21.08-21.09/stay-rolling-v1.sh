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
echo "Removing sddm-config-editor-git"
echo "Its functionality has been replaced with the ArcoLinux Tweak Tool"
echo "###############################################################################"
echo
function_remove sddm-config-editor-git
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "###############################################################################"
echo "None"
echo "###############################################################################"
echo

#sudo pacman -S --noconfirm --needed ...


echo "###############################################################################"
echo "Now we run the /usr/local/bin/arcolinux-fix-sddm-config to align you with the"
echo "new way SDDM is saving its settings"
echo "You only need to run this once"
echo "###############################################################################"

/usr/local/bin/arcolinux-fix-sddm-config

echo
echo "###############################################################################"
echo "We have also added tlp to the isos"
echo "We leave it up to you to install it manually"
echo "https://wiki.archlinux.org/title/TLP"
echo "It is about saving battery power for laptops"
echo "###############################################################################"

echo
echo "###############################################################################"
echo "WE WILL NO LONGER USE RELEASE NUMBERS IN /ETC/LSB-RELEASE"
echo "ARCOLINUX GOES ROLLING"
echo "Use the alias 'iso' to know which iso you have used to install ArcoLinux"
echo "This number will never change"
echo "###############################################################################"
echo

echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo

