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
echo "#############################"
echo "SPECIALITIES"
echo "#############################"
echo
echo "None"
echo
echo "#############################"
echo "REMOVALS"
echo "#############################"
echo "We have removed these packages from the iso :"
echo
echo "Temps : no longer maintained"
sudo pacman -R temps
echo "Font-manager - current out of date issue."
echo "We install the git version later "
sudo pacman -R font-manager
echo "Xterm - terminal from xorg has been removed from iso"
sudo pacman -R xterm
echo "Terminus font has been removed from iso"
sudo pacman -R terminus-font
echo
echo "#############################"
echo "INSTALLATIONS"
echo "#############################"
echo "We have installed these packages on the iso :"
echo
echo "ttf-hack font for terminal font e.g. termite"
sudo pacman -S ttf-hack --needed
yay -S font-manager-git --needed
echo

echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v19.11.3/' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
