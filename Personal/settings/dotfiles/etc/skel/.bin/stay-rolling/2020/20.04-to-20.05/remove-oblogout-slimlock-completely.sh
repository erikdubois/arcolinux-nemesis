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
#echo "None"
#function_remove ...
echo "Decide whether you want to keep or remove the oblogout packages"
echo "Answer y or Y if you want to remove it"
echo "Answer n or N if you want to keep it"
read response
if [[ "$response" == [yY] ]]; then
  function_remove arcolinux-oblogout
  function_remove  arcolinux-oblogout-themes-git
  if test -f /etc/oblogout.conf ; then
    sudo rm /etc/oblogout.conf
  fi
fi

echo "Decide whether you want remove slim and slim themes"
echo "Answer y or Y if you want to remove it"
echo "Answer n or N if you want to keep it"
read response
if [[ "$response" == [yY] ]]; then
  function_remove arcolinux-slim 
  function_remove arcolinux-slimlock-themes-git
fi

echo "###############################################################################"
echo "###                               DONE                                     ####"
echo "###############################################################################"
