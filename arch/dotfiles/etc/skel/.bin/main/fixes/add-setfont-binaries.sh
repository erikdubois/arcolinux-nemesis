#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Making sure KDFONTOP at boot is gone"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "###### Adding setfont to the binaries to avoid error message"
echo "###### in /etc/mkinitcpio.conf"
echo "###### and rebuilding /boot files"
echo "################################################################"
tput sgr0
echo

FIND='BINARIES=()'
REPLACE='BINARIES=(setfont)'
sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf

FIND='BINARIES=""'
REPLACE='BINARIES=(setfont)'
sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf

echo
tput setaf 2
echo "################################################################"
echo "###### Mkinitcpio and update-grub"
echo "################################################################"
tput sgr0
echo

sudo mkinitcpio -P

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo
tput setaf 6
echo "################################################################"
echo "###### KDFONTOP message is gone - reboot to check"
echo "################################################################"
tput sgr0
echo