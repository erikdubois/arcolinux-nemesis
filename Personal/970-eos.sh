#!/bin/bash
#set -e
##################################################################################################################################
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
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

# when on EOS

#######################################################################################
#
#   DECLARATION OF FUNCTIONS
#
#######################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

#######################################################################################

# when on Eos

if grep -q "EndeavourOS" /etc/os-release; then

	echo
	tput setaf 2
	echo "########################################################################"
	echo "############### We are on an EOS iso"
	echo "########################################################################"
	echo
	tput sgr0

	sudo pacman -R --noconfirm eos-settings-xfce4

	if [ -f /etc/environment ]; then
		echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo
	echo "########################################################################"
	echo "Getting latest /etc/nsswitch.conf from Nemesis"
	echo "########################################################################"
	echo
	sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
	sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/refs/heads/master/Personal/settings/nsswitch/nsswitch.conf -O /etc/nsswitch.conf

	echo
	tput setaf 6
	echo "########################################################################"
	echo "################### Done"
	echo "########################################################################"
	tput sgr0
	echo

fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo

