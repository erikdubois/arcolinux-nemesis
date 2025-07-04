#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
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

echo
tput setaf 2
echo "########################################################################"
echo "################### install folder - Software to install"
echo "########################################################################"
tput sgr0
echo
if ! grep -q "artix" /etc/os-release; then
	result=$(systemd-detect-virt)

	if [ $result = "none" ];then

		echo
		tput setaf 2
		echo "########################################################################"
		echo "####### Installing VirtualBox"
		echo "########################################################################"
		tput sgr0
		echo	

		sh install/install-virtualbox-for-linux.sh	

	else


		echo
		tput setaf 3
		echo "########################################################################"
		echo "### You are on a virtual machine - skipping VirtualBox"
		echo "########################################################################"
		tput sgr0
		echo

	fi
fi

echo
tput setaf 2
echo "########################################################################"
echo "################### Build from install folder"
echo "########################################################################"
tput sgr0
echo

if ! pacman -Qi opera &>/dev/null; then
    yay -S opera --noconfirm
else
    echo "Opera is already installed."
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
