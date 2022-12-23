#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Remove drivers I do not need for real metal"
echo "################################################################"
tput sgr0
echo

tput setaf 3;echo "  DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."
echo "  THIS MAY BRICK YOUR SYSTEM";tput sgr0

sudo pacman -R --noconfirm xf86-video-amdgpu
sudo pacman -R --noconfirm xf86-video-ati
sudo pacman -R --noconfirm xf86-video-fbdev
sudo pacman -R --noconfirm xf86-video-intel
sudo pacman -R --noconfirm xf86-video-nouveau
sudo pacman -R --noconfirm xf86-video-openchrome
sudo pacman -R --noconfirm xf86-video-vesa
sudo pacman -R --noconfirm xf86-video-vmware

echo
tput setaf 2
echo "################################################################"
echo "################### Drivers removed"
echo "################################################################"
tput sgr0
echo