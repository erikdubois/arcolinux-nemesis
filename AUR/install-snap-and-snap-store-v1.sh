#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

package="snapd"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		tput setaf 2
		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"
		tput sgr0

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		tput setaf 3
		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		tput sgr0

		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		tput setaf 3
		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		tput sgr0
		trizen -S --noconfirm --needed --noedit $package

	fi

fi


# Just checking if installation was successful
if pacman -Qi $package &> /dev/null; then

	tput setaf 2
	echo "################################################################"
	echo "#########  Checking ..."$package" has been installed"
	echo "################################################################"
	tput sgr0

else

	tput setaf 1
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!!  "$package" has NOT been installed"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	tput sgr0

fi

#----------------------------------------------------------------------------------
#what services are really needed here to avoid error after second run
#sudo systemctl enable snapd.service
sudo systemctl enable snapd.seeded.service
sudo systemctl enable snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
tput setaf 1
echo "################################################################"
echo "#########  INSTALLED FOR THE FIRST TIME THEN REBOOT AND RUN SCRIPT AGAIN"
echo "################################################################"
tput sgr0
sleep 5
sudo snap install snap-store

#fix for icons not showing
#https://forum.snapcraft.io/t/snapped-app-not-loading-fonts-on-fedora-and-arch/12484/23
sudo rm /var/cache/fontconfig/*
rm ~/.cache/fontconfig/*
echo "################################################################"
echo "#########  "$package" has been installed"
echo "################################################################"
echo "################################################################"
echo "#########  Reboot now"
echo "################################################################"

tput setaf 1
echo "################################################################"
echo "After first reboot you may need to run the script twice"
echo "known issue with too early ... message"
echo "################################################################"
tput sgr0
