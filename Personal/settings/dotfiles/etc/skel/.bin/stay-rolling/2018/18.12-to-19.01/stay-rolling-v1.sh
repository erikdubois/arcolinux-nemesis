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

echo "Installation of missing packages"

sudo pacman -S kvantum-qt5 kvantum-theme-arc --noconfirm

sudo pacman -S arcolinux-kvantum-git arcolinux-qt5-git --noconfirm


echo "################################################################"
echo "###                    All done                             ####"
echo "################################################################"
