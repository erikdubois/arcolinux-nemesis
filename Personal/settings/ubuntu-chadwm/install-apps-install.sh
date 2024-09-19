#!/bin/bash
# set -e
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
tput setaf 2
echo "################################################################"
echo "################### Installing Chadwm on Ubuntu 24.04"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "###### Installing packages"
echo "################################################################"
tput sgr0
echo

sudo apt install -y alacritty
sudo apt install -y arandr
sudo apt install -y arc-theme
sudo apt install -y btop
sudo apt install -y catfish
sudo apt install -y chromium-browser
sudo apt install -y feh
sudo apt install -y file-roller
sudo apt install -y font-manager
sudo apt install -y fonts-hack
sudo apt install -y lxappearance
sudo apt install -y meld
sudo apt install -y neofetch
sudo apt install -y nitrogen
sudo apt install -y numlockx
sudo apt install -y pavucontrol
#sudo apt install -y polkit-kde-agent-1
sudo apt install -y simplescreenrecorder
sudo apt install -y variety
sudo apt install -y vlc

git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~

git clone https://github.com/arconetpro/arconet-xfce  /tmp/arconet-xfce
cp -r /tmp/arconet-xfce/etc/skel/.config/Thunar ~/.config/

echo
tput setaf 6
echo "################################################################"
echo "###### Chadwm is installed - reboot"
echo "################################################################"
tput sgr0
echo
