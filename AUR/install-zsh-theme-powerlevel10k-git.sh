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


package="zsh-theme-powerlevel10k-git"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		tput setaf 2
		echo "######################################################################################"
		echo "################## "$package" is already installed"
		echo "######################################################################################"
		tput sgr0

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		tput setaf 3
		echo "######################################################################################"
		echo "######### Installing with yay"
		echo "######################################################################################"
		tput sgr0

		yay -S --noconfirm --needed $package

	elif pacman -Qi paru &> /dev/null; then

		tput setaf 3
		echo "######################################################################################"
		echo "######### Installing with paru"
		echo "######################################################################################"
		tput sgr0
		paru -S --noconfirm --needed $package

	fi

fi


# Just checking if installation was successful
if pacman -Qi $package &> /dev/null; then

	tput setaf 2
	echo "######################################################################################"
	echo "#########  Checking ..."$package" has been installed"
	echo "######################################################################################"
	tput sgr0

else

	tput setaf 1
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!!  "$package" has NOT been installed"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	tput sgr0

fi

#----------------------------------------------------------------------------------


package="ttf-meslo-nerd-font-powerlevel10k"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		tput setaf 2
		echo "######################################################################################"
		echo "################## "$package" is already installed"
		echo "######################################################################################"
		tput sgr0

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		tput setaf 3
		echo "######################################################################################"
		echo "######### Installing with yay"
		echo "######################################################################################"
		tput sgr0

		yay -S --noconfirm --needed $package

	elif pacman -Qi paru &> /dev/null; then

		tput setaf 3
		echo "######################################################################################"
		echo "######### Installing with paru"
		echo "######################################################################################"
		tput sgr0
		paru -S --noconfirm --needed $package

	fi

fi


# Just checking if installation was successful
if pacman -Qi $package &> /dev/null; then

	tput setaf 2
	echo "######################################################################################"
	echo "#########  Checking ..."$package" has been installed"
	echo "######################################################################################"
	tput sgr0

else

	tput setaf 1
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!!  "$package" has NOT been installed"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	tput sgr0

fi

#----------------------------------------------------------------------------------

zshPath="/home/"$USER"/.zshrc"
alacrittyPath="/home/"$USER"/.config/alacritty/alacritty.yml"
xresourcesPath="/home/"$USER"/.Xresources"

tput setaf 1
echo "######################################################################################"
echo "Beware that we add a line to your personal ~/.zshrc file at the bottom"
echo "######################################################################################"
tput sgr0
echo
echo '
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' | sudo tee --append $zshPath
echo

echo "######################################################################################"
echo "We will comment out this line  ZSH_THEME="random""
echo "######################################################################################"
echo

FIND='ZSH_THEME="random"'

REPLACE='#ZSH_THEME="random"'

sed -i "s/$FIND/$REPLACE/g" $zshPath

tput setaf 1
echo "######################################################################################"
echo "Beware that we add a line to your personal ~/.zshrc file at the bottom"
echo "######################################################################################"
tput sgr0

echo
echo "######################################################################################"
echo "We will add a line to quiet the prompt"
echo "######################################################################################"

echo '
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet' | sudo tee --append $zshPath
echo

tput setaf 1
echo "######################################################################################"
echo "Beware that we change the font in  ~/.config/alacritty/alacritty.yml"
echo "######################################################################################"
tput sgr0

FIND='family: hack'

REPLACE='family: MesloLGS NF'

sed -i "s/$FIND/$REPLACE/g" $alacrittyPath


tput setaf 1
echo "######################################################################################"
echo "Beware that we change the font in  ~/.Xresources for urxvt"
echo "######################################################################################"
tput sgr0

FIND='xft:Monospace:regular:size=11'

REPLACE='xft:MesloLGS NF:size=11'

sed -i "s/$FIND/$REPLACE/g" $xresourcesPath

tput setaf 3
echo "######################################################################################"
echo "This package has been created for ZSH"
echo "Switch to ZSH with our alias called 'tozsh'"
echo "######################################################################################"
tput sgr0

tput setaf 2
echo "######################################################################################"
echo "The package has been installed"
echo "######################################################################################"
tput sgr0




