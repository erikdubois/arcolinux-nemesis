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
echo "################### Intervention first"
echo "################################################################"
tput sgr0
echo

sh 410-intervention*

echo
tput setaf 3
echo "################################################################"
echo "################### Intervention done"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 3
echo "################################################################"
echo "################### Installing velo/velow - development software"
echo "################################################################"
tput sgr0
echo

# when NOT on a wayland session
if [ ! -d /usr/share/wayland-sessions/ ]; then
    if [ -f /usr/local/bin/velo ]; then
        velo
    fi
fi

# when on a wayland session
if [ -d /usr/share/wayland-sessions/ ]; then
    if [ -f /usr/local/bin/velow ]; then
        velow
    fi
fi


if [ ! -d /usr/share/wayland-sessions/ ]; then

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

fi

echo
tput setaf 3
echo "################################################################"
echo "################### Pacman parallel downloads to 20"
echo "################################################################"
tput sgr0
echo

FIND="ParallelDownloads = 8"
REPLACE="ParallelDownloads = 20"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

FIND="#ParallelDownloads = 5"
REPLACE="ParallelDownloads = 20"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

FIND="ParallelDownloads = 5"
REPLACE="ParallelDownloads = 20"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

echo
tput setaf 3
echo "################################################################"
echo "################### No neofetch by default"
echo "################################################################"
tput sgr0
echo

sed -i 's/^neofetch/#neofetch/' ~/.bashrc

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
sh 150-install-chadwm*
sh 160-install-bluetooth*
sh 170-install-cups*
sh 180-install-test-software*

sh 200-software-AUR-repo*
sh 500-*

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

sh 969-skel*

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
sh 970-archbang*

#has to be last - they are all Arch
sh 970-arch.sh

sh 999-what*

tput setaf 3
echo "################################################################"
echo "End current choices"
echo "################################################################"
tput sgr0
