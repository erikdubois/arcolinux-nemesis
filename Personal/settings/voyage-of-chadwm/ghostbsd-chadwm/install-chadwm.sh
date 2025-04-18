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
sudo pkg install -y font-awesome
sudo pkg install -y imlib2
sudo pkg install -y libX11
sudo pkg install -y libXft
sudo pkg install -y libXinerama
sudo pkg install -y pkgconf
sudo pkg install -y llvm

# applications to be used in Chadwm
sudo pkg install -y alacritty
sudo pkg install -y dmenu
sudo pkg install -y picom
sudo pkg install -y playerctl
sudo pkg install -y python3
sudo pkg install -y py311-distro
#sudo pkg install -y policykit-1-gnome
#sudo pkg install -y pulsemixer
sudo pkg install -y rofi
sudo pkg install -y sxhkd
sudo pkg install -y thunar
sudo pkg install -y thunar-archive-plugin
sudo pkg install -y xdg-desktop-portal-gtk

echo
tput setaf 6
echo "########################################################################"
echo "###### Powermenu"
echo "########################################################################"
tput sgr0
echo

# exit strategy - super + shift + x
folder="/tmp/arcolinux-powermenu"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### ArcoLinux Chadwm"
echo "########################################################################"
tput sgr0
echo

# getting the official code from ArcoLinux
folder="/tmp/arcolinux-chadwm"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/local/bin
sudo cp chadwm.desktop /usr/local/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### Chadwm - overwriting essential files"
echo "########################################################################"
tput sgr0
echo

# overwriting the official code from ArcoLinux with my own
cp run.sh  ~/.config/arco-chadwm/scripts
cp picom.conf  ~/.config/arco-chadwm/picom
cp config.def.h ~/.config/arco-chadwm/chadwm
cp config.mk ~/.config/arco-chadwm/chadwm
cp sxhkdrc  ~/.config/arco-chadwm/sxhkd
cp bar.sh ~/.config/arco-chadwm/scripts
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp uca.xml ~/.config/Thunar/

cd ~/.config/arco-chadwm/chadwm
make clean
make
sudo make install

echo
tput setaf 6
echo "########################################################################"
echo "###### Chadwm is installed - reboot"
echo "########################################################################"
tput sgr0
echo
