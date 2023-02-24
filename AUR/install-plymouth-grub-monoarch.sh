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

# https://wiki.archlinux.org/title/Plymouth

if [ -d /boot/loader/entries ] ; then 
	echo "You seem to be on a systemd-boot enabled system"
	echo "Run the script for systemd-boot"
	exit 1
fi

echo "###########################################################################"
echo "## This script will install plymouth and themes on a systemd-boot system ##"
echo "###########################################################################"

sudo pacman -S --noconfirm --needed plymouth
sudo pacman -S --noconfirm --needed plymouth-theme-monoarch

echo "###########################################################################"
echo "##                       Changing the needed files                       ##"
echo "###########################################################################"

FIND="base udev autodetect"
REPLACE="base udev plymouth autodetect"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf

FIND="GRUB_CMDLINE_LINUX_DEFAULT=\"quiet"
REPLACE="GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash vt.global_cursor_default=0"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/default/grub

sudo plymouth-set-default-theme -R monoarch

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "###########################################################################"
echo "#########               You have to reboot.                       #########"
echo "###########################################################################"
