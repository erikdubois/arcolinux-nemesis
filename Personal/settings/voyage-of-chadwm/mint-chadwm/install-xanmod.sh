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
echo "################### Installing Xanmod kernel"
echo "########################################################################"
tput sgr0
echo

echo
echo "########################################################################"
echo "###### Xanmod kernel via ppa"
echo "########################################################################"
echo

wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /usr/share/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list > /dev/null
sudo apt update
sudo apt install -y linux-xanmod-x64v3

echo
tput setaf 6
echo "########################################################################"
echo "################### Xanmod installed - there are more versions"
echo "########################################################################"
tput sgr0
echo
