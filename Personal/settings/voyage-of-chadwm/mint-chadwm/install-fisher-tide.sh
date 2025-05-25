#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Installing fisher and tide"
echo "########################################################################"
tput sgr0
echo
/usr/bin/fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
/usr/bin/fish -c "fisher install IlanCosman/tide@v6"
echo
tput setaf 6
echo "########################################################################"
echo "###### installing done"
echo "########################################################################"
tput sgr0
echo
