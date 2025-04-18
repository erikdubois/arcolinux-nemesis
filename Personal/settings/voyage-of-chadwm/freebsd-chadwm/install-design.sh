#!/bin/bash
# set -e
##################################################################################################################################
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

installed_dir=$(pwd)

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
echo "###### Creating folders"
echo "########################################################################"
tput sgr0
echo

# Creation of folders
[ -d $HOME"/.bin" ] || mkdir -p $HOME"/.bin"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting surfn icons"
echo "########################################################################"
tput sgr0
echo

# getting Surfn icons
folder="/tmp/surfn"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/erikdubois/Surfn  /tmp/surfn
cp -r /tmp/surfn/surfn-icons/* ~/.icons/

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting candy beauty icons"
echo "########################################################################"
tput sgr0
echo

# getting candy beauty icons
folder="/tmp/neo-candy-icons"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/neo-candy-icons  /tmp/neo-candy-icons
cp -r /tmp/neo-candy-icons/usr/share/icons/* ~/.icons/

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting arc theme"
echo "########################################################################"
tput sgr0
echo

# installing theme and cursor
sudo pkg install -y gtk-arc-themes

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting bibata cursor"
echo "########################################################################"
tput sgr0
echo

# bibata cursor
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata.tar.xz -O /tmp/bibata.tar.xz
tar -xf /tmp/bibata.tar.xz           # extract `Bibata.tar.gz`
sudo rm -rf /usr/local/share/icons/Bibata-*
sudo mv Bibata-* /usr/local/share/icons/   # Install to all users

echo
tput setaf 6
echo "########################################################################"
echo "###### installing icons ... done"
echo "########################################################################"
tput sgr0
echo
