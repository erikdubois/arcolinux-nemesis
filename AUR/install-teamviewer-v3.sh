#!/bin/bash
set -e
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

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		trizen -S --noconfirm --needed --noedit $package

	elif pacman -Qi yaourt &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yaourt"
		echo "################################################################"
		yaourt -S --noconfirm $package

	elif pacman -Qi pacaur &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with pacaur"
		echo "################################################################"
		pacaur -S --noconfirm --noedit  $package

	elif pacman -Qi packer &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with packer"
		echo "################################################################"
		packer -S --noconfirm --noedit  $package

	fi

	# Just checking if installation was successful
	if pacman -Qi $package &> /dev/null; then

	echo "################################################################"
	echo "#########  "$package" has been installed"
	echo "################################################################"

	else

	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!!  "$package" has NOT been installed"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "Teamviewer needs 32 bits applications"
	echo "Go to /etc/pacman.conf and edit these lines"
	echo "[multilib]"
	echo "Include = /etc/pacman.d/mirrorlist"
	echo "Include this mirrorlist as well"
	sleep 2
	fi

fi

sudo systemctl enable teamviewerd.service
sudo systemctl start teamviewerd.service
