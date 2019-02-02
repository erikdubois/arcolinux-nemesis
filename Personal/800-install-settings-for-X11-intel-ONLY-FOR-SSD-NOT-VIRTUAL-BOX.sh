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
echo "5. Deepin"
echo "4. Plasma"
echo "3. Xmonad"
echo "2. Cinnamon"
echo "1. ArcoLinux (xfce,openbox,i3)"
echo "0. Do nothing"
echo "Type the number..."
read CHOICE

case $CHOICE in
	5 )
      sudo cp settings/intel-uxa/20-intel.conf /etc/X11/xorg.conf.d/
      ;;
    4 )
      cp ~/.config/kwinrc ~/.config/kwinrc-backup
      cp settings/kwinrc/kwinrc ~/.config/kwinrc
      ;;
    3 )
      sudo cp settings/intel-uxa/20-intel.conf /etc/X11/xorg.conf.d/
      ;;
    2 )
      sudo cp settings/intel-uxa/20-intel.conf /etc/X11/xorg.conf.d/
      ;;
    1 )
      sudo cp settings/intel/20-intel.conf /etc/X11/xorg.conf.d/
      ;;
    0 )
        echo "########################################"
        echo "We did nothing as per your request"
        echo "########################################"
        ;;

    * )
    echo "#################################"
		echo "Choose the correct number"
    echo "#################################"
		;;
esac

echo "################################################################"
echo "#########                    done               ################"
echo "################################################################"
