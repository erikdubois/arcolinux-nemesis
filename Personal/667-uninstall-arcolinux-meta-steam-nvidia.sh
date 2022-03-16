#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
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
tput setaf 2
echo "################################################################"
echo "################### Uninstall steam"
echo "################################################################"
tput sgr0
echo

tput setaf 3;echo "  DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."
echo "  THIS MAY BRICK YOUR SYSTEM"
echo "  BUT IT IS THE ONLY WAY TO GET RID OF ALL THESE PACKAGES";tput sgr0

echo "I choose lib32-nvidia-utils at the selection of the 4 providers for lib32-vulkan-driver"

sudo pacman -Rs arcolinux-meta-steam-nvidia steam 

echo
tput setaf 2
echo "################################################################"
echo "################### Steam uninstalled"
echo "################################################################"
tput sgr0
echo