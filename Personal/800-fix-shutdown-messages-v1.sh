#!/bin/bash
set -e
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

echo "https://arcolinux.com/how-to-fix-the-ugly-lines-when-you-shutdown/"

echo "Changing /etc/mkinitcpio.conf"
sudo sed -i 's/HOOKS="base udev autodetect modconf block keyboard keymap resume filesystems fsck"/HOOKS="base udev autodetect modconf block keyboard keymap resume filesystems fsck shutdown"/g' /etc/mkinitcpio.conf

echo "running mkinitcpio"

sudo mkinitcpio -p linux

echo "################################################################"
echo "####                 CHANGES APPLIED                      ######"
echo "################################################################"
