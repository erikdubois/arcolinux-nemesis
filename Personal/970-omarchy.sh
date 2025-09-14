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

# when on omarchy

if grep -q "omarchy" /etc/plymouth/plymouthd.conf; then

	echo
	tput setaf 2
	echo "########################################################################"
	echo "############### We are on an OMARCHY iso"
	echo "########################################################################"
	echo
	tput sgr0

	# getting config
	folder="/tmp/omarchy"
	if [ -d "$folder" ]; then
	    sudo rm -r "$folder"
	fi
	git clone https://github.com/erikdubois/omarchy /tmp/omarchy
	cp -v /tmp/omarchy/config/hypr/bindings.conf ~/.config/hypr/bindings.conf
	cp -v /tmp/omarchy/config/hypr/input.conf ~/.config/hypr/input.conf
	fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo