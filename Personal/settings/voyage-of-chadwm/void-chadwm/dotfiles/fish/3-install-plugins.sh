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
echo "################### Installing the plugins"
echo "################################################################"
tput sgr0
echo

echo "We assume you have installed these packages"
echo "sudo pacman -S fish arcolinux-fish-git"
echo
echo "We assume you are now on fish and have omf installed"
echo

omf install https://github.com/jhillyerd/plugin-git
omf install fzf
omf install colored-man-pages
omf install pj

fish_update_completions

echo
tput setaf 3
echo "################################################################"
echo "################### Plugins installed"
echo "################################################################"
tput sgr0
echo