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

echo
tput setaf 2
echo "########################################################################"
echo "################### Checking if their is a Corsair K70 keyboard"
echo "########################################################################"
tput sgr0
echo

# making sure hwinfo exists in the system
if [ ! -f /usr/bin/hwinfo ]; then
  sudo apt install -y hwinfo
fi

# do we have a CORSAIR K70?
if hwinfo | grep "CORSAIR K70" > /dev/null 2>&1 ; then

	echo
	tput setaf 2
	echo "########################################################################"
	echo "################### Corsair keyboard to be installed"
	echo "########################################################################"
	tput sgr0
	echo

	sudo apt install -y ckb-next
	
	echo
	tput setaf 6
	echo "########################################################################"
	echo "################### Corsair keyboard installed"
	echo "########################################################################"
	tput sgr0
	echo

fi