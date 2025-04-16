#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "#############################"
echo "REMOVALS"
echo "#############################"
echo "Removing bluez-firmware - moved to AUR"

sudo pacman -Rs bluez-firmware

echo "Removing wpa_actiond - moved to AUR and is orphaned"

sudo pacman -Rs wpa_actiond

echo "Removing oomox - build takes super long and installs lot of software"
echo "New PKGBUILD created by maintainer"
echo "Decide if you want to keep it or not"

sudo pacman -Rs oomox

echo "Reinstalling packages we do want to keep after deleting oomox"

sudo pacman -S gtk-engines --noconfirm
sudo pacman -S optipng --noconfirm

echo "Removing old Arc themes and adding new Arc themes from Nico Hood"

sudo pacman -S arcolinux-arc-themes-nico-git

echo
echo "#############################"
echo "INSTALLATIONS"
echo "#############################"
echo "We have installed these packages on the iso :"
echo
echo "NONE"
echo


echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/v19.03.3/v19.04.4/g' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
