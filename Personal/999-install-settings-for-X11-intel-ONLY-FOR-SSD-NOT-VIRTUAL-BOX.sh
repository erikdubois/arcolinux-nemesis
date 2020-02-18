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

echo
echo "################################################################"
echo "#####  Fixing glitches in simplescreenrecorder on INTEL   ######"
echo "#####         FOR THE COMPUTER OF ERIK DUBOIS             ######"
echo "################################################################"
echo
tput setaf 1
echo "################################################################"
echo "#####  DO NOT JUST RUN THIS - THIS MIGHT BRICK YOUR SYSTEM  ####"
echo "################################################################"
tput sgr0
echo
echo "Select the correct desktop"
echo
echo "0.  Do nothing"
echo "1.  ArcoLinux (xfce,openbox,i3)"
echo "2.  Awesome"
echo "3.  Bspwm"
echo "4.  Budgie"
echo "5.  Cinnamon"
echo "6.  Deepin"
echo "7.  Gnome"
echo "8.  Herbstlufwm"
echo "9.  i3"
echo "10. LXQt"
echo "11. Mate"
echo "12. Openbox"
echo "13. Plasma"
echo "14. Qtile"
echo "15. Xfce"
echo "16. Xmonad"
echo "Type the number..."

read CHOICE

WDP=$(dirname $(readlink -f $(basename `pwd`)))

SETTING0="settings/intel/20-intel.conf"
SETTING1="settings/intel-uxa-tear-free/20-intel.conf"
SETTING2="settings/intel-uxa/20-intel.conf"
DESTINATION1="/etc/X11/xorg.conf.d/"

case $CHOICE in

    0 )
      echo
      echo "########################################"
      echo "We did nothing as per your request"
      echo "########################################"
      echo
      ;;

    1 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    2 )
      #sudo cp $WDP/$SETTING2 $DESTINATION1
      ;;
    3 )
      sudo cp $WDP/$SETTING1 $DESTINATION1
      ;;
    4 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    5 )
      sudo cp $WDP/$SETTING2 $DESTINATION1
      ;;
    6 )
      sudo cp $WDP/$SETTING2 $DESTINATION1
      ;;
    7 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    8 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    9 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    10 )
      #sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    11 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    12 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    13 )
      #if [ -f "~/.config/kwinrc" ] ;
      #then cp ~/.config/kwinrc ~/.config/kwinrc-backup
      #fi
      #cp $WDP/settings/kwinrc/kwinrc ~/.config/kwinrc
      ;;
    14 )
      sudo cp $WDP/$SETTING1 $DESTINATION1
      ;;
    15 )
      sudo cp $WDP/$SETTING0 $DESTINATION1
      ;;
    16 )
      sudo cp $WDP/$SETTING2 $DESTINATION1
      ;;
    * )
      echo "#################################"
      echo "Choose the correct number"
      echo "#################################"
      ;;
esac

echo "###########################################################"
echo "If you now realize you should not have choosen a number"
echo "Delete /etc/X11/xorg.conf.d/20-intel.conf with sudo rm"
echo "###########################################################"

echo "###########################################################"
echo "Time to reboot"
echo "###########################################################"
