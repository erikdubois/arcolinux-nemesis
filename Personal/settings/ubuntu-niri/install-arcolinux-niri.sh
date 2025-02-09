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
echo "################### Installing Niri"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "###### ArcoLinux Niri"
echo "################################################################"
tput sgr0
echo

sudo apt install -y yad
sudo apt install -y waybar
sudo apt install -y wofi
sudo apt install -y swaybg
sudo apt install -y swayidle
sudo apt install -y swaylock

cd /tmp

rm -rf /tmp/arcolinux-niri

git clone https://github.com/arcolinux/arcolinux-niri

cp -r /tmp/arcolinux-niri/etc/skel/.bin ~
cp -r /tmp/arcolinux-niri/etc/skel/.config ~
sudo cp -r /tmp/arcolinux-niri/usr/bin/run-niri /usr/bin

sudo mkdir /usr/share/wayland-session
sudo cp $installed_dir/niri.desktop /usr/share/wayland-sessions/niri.desktop

echo
tput setaf 6
echo "################################################################"
echo "###### Niri is installed - reboot"
echo "################################################################"
tput sgr0
echo
