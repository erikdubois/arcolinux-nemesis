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

if [ ! -f /usr/bin/hwinfo ]; then
  sudo pacman -S --noconfirm --needed hwinfo
fi

if hwinfo | grep "CORSAIR K70" > /dev/null 2>&1 ; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Corsair keyboard to be installed"
	echo "################################################################"
	tput sgr0
	echo

	sudo pacman -S --noconfirm --needed ckb-next-git
	installed_dir=$(pwd)
	[ -d $HOME"/.config/ckb-next" ] || mkdir -p $HOME"/.config/ckb-next"

	cp -r $installed_dir/settings/ckb-next/ckb-next.conf ~/.config/ckb-next.conf
	cp -f $installed_dir/settings/ckb-next/ckb-next.autostart.desktop ~/.config/autostart/ckb-next.autostart.desktop
	
	sudo systemctl enable ckb-next-daemon
	sudo systemctl start ckb-next-daemon

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Corsair keyboard installed"
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