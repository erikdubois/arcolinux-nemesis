#!/bin/bash
#set -e
###############################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################



echo
echo "###############################################################################"
echo "SPECIALITIES"
echo "###############################################################################"
echo
echo "Change content of /etc/mkinitcpio.conf"
echo "New mkinitcpio package"

sudo sed -i "s/sd-vconsole//g" /etc/mkinitcpio.conf
sudo mkinitcpio -P

echo
echo "###############################################################################"
echo "WE WILL NO LONGER USE RELEASE NUMBERS IN /ETC/LSB-RELEASE"
echo "ARCOLINUX GOES ROLLING"
echo "Use the alias 'iso' to know which iso you have used to install ArcoLinux"
echo "This number will never change"
echo "###############################################################################"
echo

echo "###############################################################################"
echo "###                        STAY-ROLLING DONE"
echo "###############################################################################"
echo