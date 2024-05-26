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

# we are on BigLinux

if grep -q "BigLinux" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on BigLinux"
	echo "################################################################"
	tput sgr0
	echo

	sudo rm -r /etc/skel/.config/variety/variety.conf

	echo
	echo "Installing edu packages"
	sudo pacman -S --noconfirm  edu-skel-git
  	sudo pacman -S --noconfirm  edu-xfce-git
  	sudo pacman -S --noconfirm  edu-system-git
	echo

	echo "Check if neofetch lolcat is in there"
	echo "Line may change in the future"
	
	if ! grep -q "neofetch | lolcat" $HOME/.bashrc; then
		echo "lolcat added"
		sed -i '391s/neofetch/neofetch | lolcat/g' $HOME/.bashrc
		sudo sed -i '391s/neofetch/neofetch | lolcat/g' /etc/skel/.bashrc
		echo
	fi

	# systemd

	echo "Journald.conf - volatile"

	FIND="#Storage=auto"
	REPLACE="Storage=auto"
	#REPLACE="Storage=volatile"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/systemd/journald.conf

	echo
	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo