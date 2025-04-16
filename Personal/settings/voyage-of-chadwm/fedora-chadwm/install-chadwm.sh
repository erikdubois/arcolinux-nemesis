#!/usr/bin/bash
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
echo "################### Installing Chadwm on Fedora"
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
# Credits to D3xter on Discord
# please run 'dos2unix install-chadwm.sh'to remove the hidden \r
# getting dependencies to be able to build Chadwm
sudo dnf install -y fontawesome-fonts
sudo dnf install -y imlib2-devel
sudo dnf install -y libX11-devel
sudo dnf install -y libXft-devel
sudo dnf install -y libXinerama-devel
sudo dnf install -y gcc
sudo dnf install -y make
# basic applications to be used in Chadwm
sudo dnf install -y alacritty
sudo dnf install -y arc-theme
sudo dnf install -y breeze-cursor-theme
sudo dnf install -y feh
sudo dnf install -y dash
sudo dnf install -y lxappearance
sudo dnf install -y nitrogen
sudo dnf install -y papirus-icon-theme-dark
sudo dnf install -y picom
sudo dnf install -y rofi
sudo dnf install -y sxhkd
sudo dnf install -y dmenu
sudo dnf install -y thunar
sudo dnf install -y thunar-archive-plugin
sudo dnf install -y thunar-volman
sudo dnf install -y xsetroot
# exit strategy - super + shift + x
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~

# getting the official code from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/wayland-sessions
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
#sudo dnf remove -y xdg-desktop-portal-gnome
echo
tput setaf 6
echo "################################################################"
echo "###### Chadwm is installed - reboot"
echo "################################################################"
tput sgr0
echo
