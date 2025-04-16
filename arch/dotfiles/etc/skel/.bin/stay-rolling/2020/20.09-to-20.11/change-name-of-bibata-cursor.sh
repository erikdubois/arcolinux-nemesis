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

echo "###############################################################################"
echo "SPECIALITIES"
echo "###############################################################################"
echo
echo "Bibata cursor update - developer changed the name"
echo "Change name to Bibata-Modern-Ice in /usr/share/icons/default/index.theme"
echo
find /usr/share/icons/default/index.theme -type f -exec sudo sed -i "s/Bibata_Ice/Bibata-Modern-Ice/g" {} \;
echo "###############################################################################"
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
