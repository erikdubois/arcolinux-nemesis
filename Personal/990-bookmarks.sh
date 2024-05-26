#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "#####                      Choose wisely                    ####"
echo "################################################################"
tput sgr0
echo
echo "Select the correct desktop"
echo
echo "0.  Do nothing"
echo "1.  Carli"
echo "2.  Alci"
echo "3.  Ariser"
echo "Type the number..."

read CHOICE

case $CHOICE in

    0 )
      echo
      echo "########################################"
      echo "We did nothing as per your request"
      echo "########################################"
      echo
      ;;

    1 )
			echo
			echo "Changing the bookmarks"
			echo
			cp $installed_dir/settings/carli/bookmarks ~/.config/gtk-3.0/bookmarks
      echo
      echo "Everything set"
      ;;
    2 )
			echo
			echo "Changing the bookmarks"
			echo
			cp $installed_dir/settings/alci/bookmarks ~/.config/gtk-3.0/bookmarks
      echo
      echo "Everything set"
      ;;
    3 )
			echo
			echo "Changing the bookmarks"
			echo
			cp $installed_dir/settings/ariser/bookmarks ~/.config/gtk-3.0/bookmarks
      echo
      echo "Everything set"
      ;;
    * )
      echo "#################################"
      echo "Choose the correct number"
      echo "#################################"
      ;;
esac

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo