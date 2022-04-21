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

# software from AUR (Arch User Repositories)
# https://aur.archlinux.org/packages/

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

echo
tput setaf 2
echo "################################################################"
echo "################### AUR Folder - Software to install"
echo "################################################################"
tput sgr0
echo

result=$(systemd-detect-virt)

if [ $result = "none" ];then

	echo
	tput setaf 2
	echo "################################################################"
	echo "####### Installing VirtualBox"
	echo "################################################################"
	tput sgr0
	echo	

	sh AUR/install-virtualbox-for-linux-v2.sh	

else


	echo
	tput setaf 2
	echo "################################################################"
	echo "### You are on a virtual machine - skipping VirtualBox"
	echo "################################################################"
	tput sgr0
	echo

fi

# these come last always
echo "Checking if icons from applications have a hardcoded path"
echo "and fixing them"
echo "Wait for it ..."

sudo hardcode-fixer

echo
tput setaf 2
echo "################################################################"
echo "################### AUR Software installed"
echo "################################################################"
tput sgr0
echo
