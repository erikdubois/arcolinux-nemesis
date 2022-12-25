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
echo "################### Bluetooth"
echo "################################################################"
tput sgr0
echo

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}


installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

if [ ! -f /usr/share/xsessions/plasma.desktop ]; then
  sudo pacman -S --noconfirm --needed blueberry
fi

sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

if ! grep -q "load-module module-switch-on-connect" /etc/pulse/system.pa; then
    echo 'load-module module-switch-on-connect' | sudo tee --append /etc/pulse/system.pa
fi

if ! grep -q "load-module module-bluetooth-policy" /etc/pulse/system.pa; then
    echo 'load-module module-bluetooth-policy' | sudo tee --append /etc/pulse/system.pa
fi

if ! grep -q "load-module module-bluetooth-discover" /etc/pulse/system.pa; then
    echo 'load-module module-bluetooth-discover' | sudo tee --append /etc/pulse/system.pa
fi

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo