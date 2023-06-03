#!/bin/bash
#set -e
##################################################################################################################
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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "Do you want to install Chadwm on your system?"
echo "Answer with Y/y or N/n"
echo "################################################################"
tput sgr0
echo

read response

if [[ "$response" == [yY] ]]; then
    touch /tmp/install-chadwm
fi


echo
echo "Pacman parallel downloads if needed -for ArcoLinux"
FIND="ParallelDownloads = 8"
REPLACE="ParallelDownloads = 20"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

echo
echo "Pacman parallel downloads if needed - for Arch Linux"
FIND="#ParallelDownloads = 5"
REPLACE="ParallelDownloads = 20"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

echo
tput setaf 3
echo "################################################################"
echo "################### Start current choices"
echo "################################################################"
tput sgr0
echo

sudo pacman -Sy

sh 400-remove-software*

sh 100-install-nemesis-software*
sh 110-install-arcolinux-software*
sh 120-install-core-software*
#sh 130-install-leftwm*
sh 150-install-chadwm*
sh 160-install-bluetooth*
sh 170-install-cups*

sh 200-software-AUR-repo*
#sh 300-sardi-extra-icons-AUR-repo*
#sh 310-sardi-mint-y-icons-AUR-repo*
#sh 320-surfn-mint-y-icons-git-AUR-repo*

sh 500-what*

echo
tput setaf 3
echo "################################################################"
echo "################### Going to the Personal folder"
echo "################################################################"
tput sgr0
echo

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
cd $installed_dir/Personal

sh 900-*
sh 910-*
sh 920-*
sh 930-*
sh 940-*
sh 950-*

sh 960-*

sh 970-all*

sh 970-alci*
sh 970-archman*
sh 970-archcraft*
sh 970-arco*
sh 970-ariser*
sh 970-carli*
sh 970-eos*
sh 970-garuda*
sh 970-sierra*
sh 970-biglinux*
sh 970-rebornos*

#has to be last - they are all Arch
sh 970-arch.sh


sh 999-skel*

tput setaf 3
echo "################################################################"
echo "End current choices"
echo "################################################################"
tput sgr0
