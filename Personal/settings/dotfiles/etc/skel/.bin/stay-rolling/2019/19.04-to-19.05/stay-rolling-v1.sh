#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "#############################"
echo "REMOVALS"
echo "#############################"
echo "Removing redshift - still issues with geoip for some users - no frustrating apps"

sudo pacman -Rs redshift

echo
echo "#############################"
echo "INSTALLATIONS"
echo "#############################"
echo "We have installed these packages on the iso :"
echo
echo "NONE"
echo

echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/v19.04.4/v19.05.2/g' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
