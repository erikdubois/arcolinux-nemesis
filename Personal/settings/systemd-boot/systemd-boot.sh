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
#https://peterconfidential.com/grub-to-systemd-boot/
#https://bbs.archlinux.org/viewtopic.php?id=223909

echo
tput setaf 2
echo "################################################################"
echo "################### Search for keys"
echo "################################################################"
tput sgr0
echo

sudo pacman -S --noconfirm --needed systemd-boot-pacman-hook

sudo bootctl install

sudo pacman -Rcnsu grub

echo
tput setaf 2
echo "################################################################"
echo "################### keys found"
echo "################################################################"
tput sgr0
echo