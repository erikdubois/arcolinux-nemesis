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
echo "qt5-styleplugins - moved to AUR - not needed anymore"
function_remove qt5-styleplugins
echo "We have removed this package from the iso :"
echo "aurvote-git - moved to AUR - orphaned"
function_remove aurvote-git
echo "We have removed this package from the iso :"
echo "libatomic_ops - not part of archiso anymore"
function_remove libatomic_ops
echo
echo "###############################################################################"
echo "INSTALLATIONS"
echo "###############################################################################"
echo "We have installed these packages on the iso :"
echo
echo "We have moved the update-mirrors service to a separate package"
sudo pacman -S arcolinux-systemd-services-git --noconfirm --needed
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
echo "###############################################################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "###############################################################################"
echo
sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v20.6.5/' /etc/lsb-release

echo "###############################################################################"
echo "###                LSB-RELEASE NUMBER UPDATED               ####"
echo "###############################################################################"
