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
echo "################### Installing Chadwm on Nobara"
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
sudo yum install -y python3-XStatic-Font-Awesome.noarch
sudo yum install -y imlib2-devel.x86_64
sudo yum install -y libX11-devel-1.8.9-1.fc40.x86_64
sudo yum install -y libXft-devel.x86_64
sudo yum install -y libXinerama-devel.x86_64

# figure out what driver you need on your hardware - there are many choices
sudo yum install -y xorg-x11-drv-intel-2.99.917-57.20210115.fc40.x86_64

# applications to be used in Chadwm
sudo yum install -y alacritty
sudo yum install -y dash
sudo yum install -y dmenu
sudo yum install -y picom
sudo yum install -y playerctl
sudo yum install -y polkit-gnome.x86_64
sudo yum install -y rofi
sudo yum install -y sxhkd
sudo yum install -y thunar
sudo yum install -y thunar-archive-plugin
sudo yum install -y thunar-volman
sudo yum install -y xsetroot

# exit strategy - super + shift + x
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~

# getting the official code from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~

# overwriting the official code from ArcoLinux with my own
cp run.sh  ~/.config/arco-chadwm/scripts
cp picom.conf  ~/.config/arco-chadwm/picom
cp config.def.h ~/.config/arco-chadwm/chadwm
cp config.mk ~/.config/arco-chadwm/chadwm
cp sxhkdrc  ~/.config/arco-chadwm/sxhkd
cp bar.sh ~/.config/arco-chadwm/scripts
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp uca.xml ~/.config/Thunar/

# building Chadwm
cd ~/.config/arco-chadwm/chadwm
./rebuild.sh
# removing this package - it slows down terminals and thunar
sudo yum remove -y xdg-desktop-portal-gnome.x86_64
echo
tput setaf 6
echo "########################################################################"
echo "###### Chadwm is installed - reboot"
echo "########################################################################"
tput sgr0
echo
