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
echo "################### All in one for AnduinOS"
echo "########################################################################"
tput sgr0
echo

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y apt-transport-https 
sudo apt install -y ca-certificates
sudo apt install -y curl
sudo apt install -y software-properties-common
sudo apt install -y wget
sudo apt install -y gnupg

./install-chadwm.sh
./install-apps-install.sh
./install-apps-local.sh
./install-apps-ppa.sh
./install-apps-snap.sh
# personal stuff
./install-ckb-next.sh
./install-design.sh
./personal-configs.sh

sudo apt autoremove -y

echo
echo "########################################################################"
echo "###### Building Chadwm"
echo "########################################################################"
echo

# building Chadwm
cd ~/.config/arco-chadwm/chadwm
./rebuild.sh

echo
tput setaf 6
echo "########################################################################"
echo "###### All in one done"
echo "########################################################################"
tput sgr0
echo
