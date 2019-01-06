#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website : https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


echo "################################################################"
echo "#########          Copying 20-intel.conf         ################"
echo "################################################################"

echo "Select the correct desktop"
echo "2. Xmonad"
echo "1. Cinnnamon"
echo "0. Rest"
echo "Type the number..."
read CHOICE

case $CHOICE in
    2 )
      sudo cp settings/intel-uxa/20-intel.conf /etc/X11/xorg.conf.d/
      ;;

    1 )
      sudo cp settings/intel-uxa/20-intel.conf /etc/X11/xorg.conf.d/
      ;;
    0 )
      sudo cp settings/intel/20-intel.conf /etc/X11/xorg.conf.d/
      ;;

    * )
		echo "Nothing changed..."
		;;
esac

echo "################################################################"
echo "#########                    done               ################"
echo "################################################################"
