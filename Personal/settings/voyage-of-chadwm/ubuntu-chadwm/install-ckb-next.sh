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
    echo "Debug mode is on. Press Enter to continue..."
    read dummy
    echo
fi

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Checking if their is a Corsair K70 keyboard"
echo "########################################################################"
echo "This may take a while - scanning ..."
tput sgr0
echo

# making sure hwinfo exists in the system
if [ ! -f /usr/bin/hw-probe ]; then
  sudo apt install -y hw-probe
fi

# do we have a CORSAIR K70?
if sudo hwinfo | grep "CORSAIR K70" > /dev/null 2>&1 ; then

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

else

	echo
	tput setaf 6
	echo "########################################################################"
	echo "################### No Corsair keyboard present"
	echo "########################################################################"
	tput sgr0
	echo

fi
