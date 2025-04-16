#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
echo "################################################################"
echo "Disabling services"
echo "################################################################"

sudo systemctl disable tlp.service
sudo systemctl disable tlp-sleep.service

echo "################################################################"
echo "Uninstalling packages"
echo "################################################################"

sudo pacman -R tlp

echo "################################################################"
echo "###  Tlp and all related packages and services are gone     ####"
echo "################################################################"
