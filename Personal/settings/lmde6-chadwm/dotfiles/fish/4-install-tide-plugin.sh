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

echo
tput setaf 3
echo "################################################################"
echo "################### Installing the tide plugin"
echo "################### Conflicts with other themes"
echo "################################################################"
tput sgr0
echo

echo "We assume you have installed these packages"
echo "sudo pacman -S fish arcolinux-fish-git"
echo

sudo pacman -S --noconfirm fisher
fisher install IlanCosman/tide@v6

echo
tput setaf 3
echo "################################################################"
echo "################### Plugin installed"
echo
echo "################### Now you can configure the tide plugin"
echo
echo "################### Type in a terminal:"
echo "################### reload"
echo "################### tide configure"
echo "################################################################"
tput sgr0
echo