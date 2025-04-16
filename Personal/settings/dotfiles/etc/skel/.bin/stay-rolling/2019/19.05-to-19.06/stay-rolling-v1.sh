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

sudo sed -i 's/v19.05.2/v19.06.1/g' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
