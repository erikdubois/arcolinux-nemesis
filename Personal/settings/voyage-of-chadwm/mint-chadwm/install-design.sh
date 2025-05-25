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
echo "################### Installing design"
echo "########################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "########################################################################"
echo "###### Creating essential missing directories"
echo "########################################################################"
tput sgr0
echo

# Creation of folders
[ -d $HOME"/.bin" ] || mkdir -pv $HOME"/.bin"
[ -d $HOME"/.fonts" ] || mkdir -pv $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -pv $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -pv $HOME"/.themes"

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing icons"
echo "########################################################################"
tput sgr0
echo

# getting Surfn icons
rm -rf /tmp/surfn
git clone https://github.com/erikdubois/Surfn  /tmp/surfn
cp -r /tmp/surfn/surfn-icons/* ~/.icons/
echo

# getting candy beauty icons
rm -rf /tmp/neo-candy-icons
git clone https://github.com/erikdubois/neo-candy-icons  /tmp/neo-candy-icons
cp -rf /tmp/neo-candy-icons/usr/share/icons/* ~/.icons/
echo

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing theme"
echo "########################################################################"
tput sgr0
echo

# installing theme and cursor
sudo apt install -y arc-theme

echo
tput setaf 6
echo "########################################################################"
echo "###### installing design ... done"
echo "########################################################################"
tput sgr0
echo
