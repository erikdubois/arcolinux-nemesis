#!/bin/fish
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Installing the themes"
echo "################################################################"
tput sgr0
echo

echo "We assume you have installed these packages"
echo "sudo pacman -S fish arcolinux-fish-git"
echo
echo "We assume you are now on fish and have omf installed"
echo

omf install lambda
omf install bobthefish

echo
tput setaf 3
echo "################################################################"
echo "################### Themes installed"
echo "################################################################"
tput sgr0
echo