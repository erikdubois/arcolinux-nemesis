#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################


if grep -q "ArchBang" /etc/os-release; then

  echo
  tput setaf 3
  echo "################################################################"
  echo "################### Intervention first for ArchBang"
  echo "################################################################"
  tput sgr0
  echo

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### We are on ArchBang"
  echo "################################################################"
  tput sgr0
  echo


  if [ -f /usr/local/bin/fixkey ]; then
    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Running fixkey if it exists"
    echo "################################################################"
    tput sgr0
    echo
    /usr/local/bin/fixkey
  fi

  echo "Making backups of important files to start openbox"

  if [ ! -f $HOME/.bash_profile_nemesis ]; then
    cp -vf $HOME/.bash_profile $HOME/.bash_profile_nemesis
  fi

  if [ ! -f $HOME/.xinitrc-nemesis ]; then
    cp -vf $HOME/.xinitrc $HOME/.xinitrc-nemesis
  fi

  sudo cp mirrorlist /etc/pacman.d/mirrorlist

  echo
  echo "Change to zstd in mkinitcpio"
  echo
  FIND="COMPRESSION=\"xz\""
  REPLACE="COMPRESSION=\"zstd\""
  sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf
  sudo mkinitcpio -P

  echo
  tput setaf 6
  echo "######################################################"
  echo "###################  $(basename $0) done"
  echo "######################################################"
  tput sgr0
  echo

fi

