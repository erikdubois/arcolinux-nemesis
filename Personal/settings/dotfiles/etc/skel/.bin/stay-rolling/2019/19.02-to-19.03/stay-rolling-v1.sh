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

echo "Removing papirus-icon-theme-git - orphaned"

sudo pacman -Rs papirus-icon-theme-git

echo "Installing papirus-icon-theme"

sudo pacman -S papirus-icon-theme

echo "#############################"
echo "INSTALLATIONS"
echo "#############################"
echo "We have installed these packages on the iso :"
echo
echo "- redshift"
echo "- the_platinum_searcher-bin"

sudo pacman -S redshift
yay -S the_platinum_searcher-bin

echo "We developed a grub theme for the iso"

sudo pacman -S arcolinux-grub-theme-vimix-git

echo "#############################"
echo "REMOVALS"
echo "#############################"

echo "We removed these packages from the iso"
echo "- hplip"
echo "If you have an HP printer, you better keep this"

sudo pacman -Rs hplip


echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/v19.02.4/v19.03.3/g' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
