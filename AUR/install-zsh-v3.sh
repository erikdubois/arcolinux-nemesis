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

package="zsh"

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

package="zsh-completions"

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

package="zsh-syntax-highlighting"

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

# Installation of OH-MY-ZSH from the github (best way to install!!)

echo "################################################################"
echo "downloading Oh-My-Zsh from github"
echo "################################################################"

wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

# changing the theme to random so you can enjoy tons of themes.

sudo sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"random\"/g' ~/.zshrc

# If above line did not work somehow. This is what you should do to enjoy the many themes.
# go find the hidden .zshrc file and look for ZSH_THEME="robbyrussell" (CTRL+H to find hidden files)
# change this to ZSH_THEME="random"

echo '
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
neofetch
' >>  ~/.zshrc
