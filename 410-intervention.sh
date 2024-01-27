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

if grep -q "ArchBang" /etc/os-release; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### We are on ArchBang"
  echo "################################################################"
  tput sgr0
  echo

  echo "Making backups of important files to start openbox"
  if ! -f /etc/skel/.bash_profile_nemesis; then
    sudo cp -f /etc/skel/.bash_profile /etc/skel/.bash_profile_nemesis
  fi
  if ! $HOME/.bash_profile_nemesis; then
    sudo cp -f $HOME/.bash_profile $HOME/.bash_profile_nemesis
  fi
  if ! $HOME/.xinitrc-nemesis;
    sudo cp -f $HOME/.xinitrc $HOME/.xinitrc-nemesis
  fi

  echo
  tput setaf 6
  echo "################################################################"
  echo "################### Done"
  echo "################################################################"
  tput sgr0
  echo

fi

