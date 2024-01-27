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

if grep -q "ArchBang" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ArchBang"
	echo "################################################################"
	tput sgr0
	echo

	echo "Removing conflicting files"
	sudo rm -f /etc/skel/.config/variety/variety.conf

	echo "Variety conf ArcoLinux"
	sudo pacman -S --noconfirm --needed arcolinux-variety-git
	sudo pacman -S --noconfirm --needed arcolinux-variety-autostart-git

	echo
	echo "Adding nanorc"
	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	echo
	echo "Setting environment variables"
	echo
	if [ -f /etc/environment ]; then
		echo "XDG_CURRENT_DESKTOP=openbox" | sudo tee -a /etc/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo	
	echo "When on Openbox"
	if [ -f /usr/share/xsessions/openbox.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Openbox"
		echo "################################################################"
		tput sgr0
		echo

		echo "Changing theme and icon theme"
		sudo pacman -S --noconfirm --needed openbox-arc-git 
		sudo pacman -S --noconfirm --needed arcolinux-openbox-themes-git

	fi

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

