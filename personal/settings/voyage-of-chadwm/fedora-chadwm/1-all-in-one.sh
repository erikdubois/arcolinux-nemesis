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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### All in one for Fedora"
echo "########################################################################"
tput sgr0
echo

sudo dnf upgrade -y

dos2unix ./install-chadwm.sh
./install-chadwm.sh
./install-apps-install.sh
./install-design.sh
./personal-configs.sh

sudo dnf update -y
sudo dnf upgrade -y
sudo dnf autoremove -y

echo
tput setaf 6
echo "########################################################################"
echo "###### All in one done"
echo "###### Figure out what driver you need"
echo "###### xorg-x11...."
echo "########################################################################"
tput sgr0
echo
