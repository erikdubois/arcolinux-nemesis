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

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then
  if grep -q arcolinux_repo /etc/pacman.conf; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################ ArcoLinux repos are already in /etc/pacman.conf"
    echo "################################################################"
    tput sgr0
    echo
    else
    #get the keys and mirrors for ArcoLinux
    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Getting the keys and mirrors for ArcoLinux"
    echo "################################################################"
    tput sgr0
    echo
    sh arch/get-the-keys-and-repos.sh
    sudo pacman -Sy
  fi
fi


if grep -q "alci" /usr/local/bin/get-nemesis; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on an ALCI iso"
	echo "################################################################"
	tput sgr0
	echo

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo
	fi

	if [ -f /usr/share/xsessions/plasma.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Plasma"
		echo "################################################################"
		tput sgr0
		echo
	fi

	if [ -f /usr/share/xsessions/mate.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Mate"
		echo "################################################################"
		tput sgr0
		echo
	fi

	if [ -f /usr/share/xsessions/cinnamon.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Cinnamon"
		echo "################################################################"
		tput sgr0
		echo
	fi	

fi
