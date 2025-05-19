#!/bin/bash
#set -e
##################################################################################################################################
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
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

if grep -q "artix" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Artix"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"

fi

if grep -q "rebornos" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on RebornOS"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"

fi

if grep -q "archcraft" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Archcraft"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"

fi

if grep -q "CachyOS" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Cachyos"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"

fi


if grep -q "Manjaro" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Manjaro"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"

fi

if grep -q "Garuda" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Garuda"
  echo "########################################################################"
  tput sgr0
  echo

  # putting back the original pacman.conf
  sudo cp -v /etc/pacman.conf.nemesis /etc/pacman.conf

# Define the lines to append
config_block="
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/\$repo/\$arch
"

  # Append to /etc/pacman.conf
  echo "$config_block" | sudo tee -a /etc/pacman.conf > /dev/null

  echo "Repository (nemesis) added to /etc/pacman.conf"

fi

if grep -q "ArchBang" /etc/os-release; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on ArchBang"
  echo "########################################################################"
  tput sgr0
  echo

  echo "Making backups of important files to start openbox"

  if [ ! -f $HOME/.bash_profile_nemesis ]; then
    cp -vf $HOME/.bash_profile $HOME/.bash_profile_nemesis
  fi

  if [ ! -f $HOME/.xinitrc-nemesis ]; then
    cp -vf $HOME/.xinitrc $HOME/.xinitrc-nemesis
  fi
  if [ ! -d "$HOME/.bin" ]; then
    mkdir "$HOME/.bin"
  fi
  cp "/home/$USER/AB_Scripts/startpanel" "$HOME/.bin/startpanel"


  echo "Getting our mirrorlist in"
  sudo cp mirrorlist /etc/pacman.d/mirrorlist

  echo
  echo "Change from xz to zstd in mkinitcpio"
  echo
  FIND="COMPRESSION=\"xz\""
  REPLACE="COMPRESSION=\"zstd\""
  sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf
  sudo mkinitcpio -P

  echo
  tput setaf 6
  echo "##############################################################"
  echo "###################  $(basename $0) done"
  echo "##############################################################"
  tput sgr0
  echo

fi

