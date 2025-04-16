#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
echo "#############################"
echo "SPECIALITIES"
echo "#############################"
echo "Adding the current user to the group rfkill :"
echo "In order to be able to switch blueberry on and off"
# https://github.com/linuxmint/blueberry/issues/75
sudo usermod  -a -G rfkill $USER
echo

echo "#############################"
echo "REMOVALS"
echo "#############################"
echo "We have removed these packages from the iso :"
echo
echo "NONE"
echo

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

sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v19.07.9/' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
