#!/bin/bash
set -e
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

#dependencies

sudo pacman -S lib32-fontconfig  --needed --noconfirm
sudo pacman -S lib32-libpng12 --needed --noconfirm
sudo pacman -S lib32-libsm --needed --noconfirm
sudo pacman -S lib32-libxinerama --needed --noconfirm
sudo pacman -S lib32-libxrender --needed --noconfirm
sudo pacman -S lib32-libjpeg6-turbo --needed --noconfirm
sudo pacman -S lib32-libxtst --needed --noconfirm
sudo pacman -S lib32-dbus --needed --noconfirm
sudo pacman -S lib32-freetype2 --needed --noconfirm

# wget https://archive.archlinux.org/packages/l/lib32-freetype2/lib32-freetype2-2.8-2-x86_64.pkg.tar.xz
# sudo pacman -U lib32-freetype2-2.8-2-x86_64.pkg.tar.xz --needed --noconfirm
# rm ./lib32-freetype2-2.8-2-x86_64.pkg.tar.xz

package="teamviewer"

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
	echo "Teamviewer needs 32 bits applications"
	echo "Go to /etc/pacman.conf and edit these lines"
	echo "[multilib]"
	echo "Include = /etc/pacman.d/mirrorlist"
	echo "Include this mirrorlist as well"
	sleep 2
	tput sgr0

fi

#----------------------------------------------------------------------------------

sudo systemctl enable teamviewerd.service
sudo systemctl start teamviewerd.service
