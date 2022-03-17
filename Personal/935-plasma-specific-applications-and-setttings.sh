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

echo
tput setaf 2
echo "################################################################"
echo "################### Plasma settings to be installed"
echo "################################################################"
tput sgr0
echo



if [ -f /usr/bin/startplasma-x11 ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Bookmarks plasma to be installed"
	echo "################################################################"
	tput sgr0
	echo

	installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
	cp $installed_dir/settings/plasma/bookmarks/user-places.xbel ~/.local/share/user-places.xbel
	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Bookmarks plasma installed"
	echo "################################################################"
	tput sgr0
	
fi
