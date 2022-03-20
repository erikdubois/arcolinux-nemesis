#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
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
	installed_dir=$(dirname `pwd`)
	[ -d $HOME"/.config/ckb-next" ] || mkdir -p $HOME"/.config/ckb-next"
	#cp -r $installed_dir/Personal/settings/ckb-next/ckb-next.conf ~/.config/ckb-next.conf
	sudo systemctl enable ckb-next-daemon
	sudo systemctl start ckb-next-daemon

	cp -f $installed_dir/settings/ckb-next/ckb-next.desktop $HOME"/.config/autostart/ckb-next.desktop"

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Corsair keyboard installed"
	echo "################################################################"
	tput sgr0
	echo

fi
