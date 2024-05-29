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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################

# when on MANJARO

###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

###############################################################################

# when on Manjaro

if grep -q "Manjaro" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "############### We are on an Manjaro iso"
	echo "################################################################"
	echo
	tput sgr0

	sudo pacman -R --noconfirm sardi-icons
	sudo pacman -R --noconfirm qt5ct
	sudo pacman -R --noconfirm qt6ct
  	sudo pacman -R --noconfirm surfn-icons-git
  	sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git 
  	sudo pacman -S --noconfirm --needed arcolinux-meta-plasma-design
  	sudo rm -f /etc/skel/.config/variety/variety.conf
  	sudo pacman -S --noconfirm --needed arcolinux-variety-git
  	sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf

	if [ -f /etc/environment ]; then
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

	if ! grep -q "wobblywindowsEnabled=true" $HOME/.config/kwinrc; then
echo '

[Plugins]
wobblywindowsEnabled=true' | sudo tee -a ~/.config/kwinrc
  	fi

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo
