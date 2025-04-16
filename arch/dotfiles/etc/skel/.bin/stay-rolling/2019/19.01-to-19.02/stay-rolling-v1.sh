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

echo "Removing transmission-gtk and tranmission-cli"

sudo pacman -Rs transmission-gtk transmission-cli

echo "Installing qtbittorrent"

sudo pacman -S qbittorrent


echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/v19.01.4/v19.02.4/g' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
