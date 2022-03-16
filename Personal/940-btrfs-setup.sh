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

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Snapper to be installed"
	echo "################################################################"
	tput sgr0
	echo	
	echo "You are using BTRFS. Installing the software ..."
	sudo pacman -S --needed --noconfirm snapper
	sudo pacman -S --needed --noconfirm grub-btrfs
	sudo pacman -S --needed --noconfirm btrfs-assistant
	sudo pacman -S --needed --noconfirm snap-pac
	sudo pacman -S --needed --noconfirm snapper-support
	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Snapper installed"
	echo "################################################################"
	tput sgr0
	echo	

else

	echo
	tput setaf 2
	echo "################################################################"
	echo "### Your harddisk/ssd/nvme is not formatted as BTRFS."
	echo "### Packages will not be installed."
	echo "################################################################"
	tput sgr0
	echo
fi