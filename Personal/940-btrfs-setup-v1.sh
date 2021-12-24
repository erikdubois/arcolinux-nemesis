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

if 	lsblk -f | grep btrfs > /dev/null 2>&1 ; then
	echo "You are using BTRFS. Installing the software ..."
	sudo pacman -S --needed --noconfirm timeshift
	sudo pacman -S --needed --noconfirm grub-btrfs
	sudo pacman -S --needed --noconfirm timeshift-autosnap
	sudo systemctl enable grub-btrfs.path
else
	echo "Your harddisk/ssd/nvme is not formatted as BTRFS."
	echo "Packages will not be installed"
fi

echo "################################################################"
echo "#########   Packages installed - Reboot now     ################"
echo "################################################################"
