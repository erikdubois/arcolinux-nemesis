#!/bin/bash
#set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website   :   https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


#
sudo pacman -R arcolinux-plasma-git --noconfirm
sudo pacman -S arcolinux-plasma-nemesis-git --noconfirm --needed
#
sudo pacman -R arcolinux-config-git --noconfirm
sudo pacman -R arcolinux-config-plasma-git --noconfirm
sudo pacman -S arcolinux-config-plasma-nemesis-git --noconfirm --needed
#
#
sudo pacman -R arcolinux-qt5-git --noconfirm
sudo pacman -S arcolinux-qt5-plasma-git --noconfirm --needed
#
cp -rT /etc/skel ~

echo "################################################################"
echo "####                 PLASMA  INSTALLED                    ######"
echo "################################################################"
