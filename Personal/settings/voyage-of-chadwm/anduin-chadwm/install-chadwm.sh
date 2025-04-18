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
echo "################### Installing Chadwm"
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

# getting dependencies to be able to build Chadwm
sudo apt install -y build-essential
sudo apt install -y fonts-font-awesome
sudo apt install -y libimlib2-dev
sudo apt install -y libx11-dev
sudo apt install -y libxft-dev
sudo apt install -y libxinerama-dev

# applications to be used in Chadwm
sudo apt install -y alacritty
sudo apt install -y arandr
sudo apt install -y lxappearance
sudo apt install -y neofetch
sudo apt install -y picom
sudo apt install -y playerctl
sudo apt install -y policykit-1-gnome
sudo apt install -y pulsemixer
sudo apt install -y rofi
sudo apt install -y sxhkd
# next item is dmenu
sudo apt install -y suckless-tools
sudo apt install -y thunar
sudo apt install -y thunar-archive-plugin
sudo apt install -y thunar-volman

# exit strategy - super + shift + x
folder="/tmp/arcolinux-powermenu"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~

# getting the official code from ArcoLinux
folder="/tmp/arcolinux-chadwm"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~

# overwriting the official code from ArcoLinux with my own
cp run.sh  ~/.config/arco-chadwm/scripts
cp picom.conf  ~/.config/arco-chadwm/picom
cp config.def.h ~/.config/arco-chadwm/chadwm
cp sxhkdrc  ~/.config/arco-chadwm/sxhkd
cp bar.sh ~/.config/arco-chadwm/scripts
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp uca.xml ~/.config/Thunar/


# removing this package - it slows down terminals and thunar
# this will remove the complete ubuntu desktop in 24.10 not in 24.04
sudo apt remove -y xdg-desktop-portal-gnome

sudo apt autoremove -y

echo
echo "########################################################################"
echo "###### Alacritty"
echo "########################################################################"
echo
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update -y
sudo apt install alacritty -y

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
echo "###### Chadwm is installed - reboot"
echo "########################################################################"
tput sgr0
echo
