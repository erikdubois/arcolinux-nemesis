#!/bin/bash
#set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website : https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

sudo pacman -S --needed --noconfirm timeshift
sudo pacman -S --needed --noconfirm grub-btrfs
sudo pacman -S --needed --noconfirm timeshift-autosnap

sudo systemctl enable grub-btrfs.path

echo "################################################################"
echo "#########   Packages installed - Reboot now     ################"
echo "################################################################"
