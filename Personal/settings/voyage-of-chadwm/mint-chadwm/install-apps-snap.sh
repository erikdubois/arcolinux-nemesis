#!/bin/bash
# set -e
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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    echo "Debug mode is on. Press Enter to continue..."
    read dummy
    echo
fi

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Installing snap software"
echo "########################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing packages"
echo "########################################################################"
tput sgr0
echo
# https://snapcraft.io/docs/installing-snap-on-linux-mint

FILE=/etc/apt/preferences.d/nosnap.pref

if [ -f "$FILE" ]; then
    echo "Removing $FILE..."
    sudo rm "$FILE"
else
    echo "$FILE does not exist. Skipping."
fi

sudo apt install -y snapd

# installing software
sudo snap install brave --classic
#sudo snap install colorwall --classic
sudo snap install code --classic
#sudo snap install discord --classic
#sudo snap install gitkraken --classic
sudo snap install opera --classic
sudo snap install spotify --classic
#sudo snap install telegram-desktop --classic
sudo snap install vivaldi --classic

echo
tput setaf 6
echo "########################################################################"
echo "###### Done installing snap software"
echo "########################################################################"
tput sgr0
echo
