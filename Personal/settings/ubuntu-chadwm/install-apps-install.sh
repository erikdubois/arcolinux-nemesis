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
echo "###### Installing packages with apt install"
echo "################################################################"
tput sgr0
echo

sudo apt install -y apt-file
sudo apt install -y arandr
sudo apt install -y bat
sudo apt install -y btop
sudo apt install -y catfish
sudo apt install -y chromium-browser
sudo apt install -y curl
sudo apt install -y dex
sudo apt install -y dconf-editor
sudo apt install -y duf
sudo apt install -y feh
sudo apt install -y file-roller
sudo apt install -y flameshot
sudo apt install -y flatpak
sudo apt install -y font-manager
sudo apt install -y fonts-hack
sudo apt install -y fonts-noto
sudo apt install -y fonts-roboto
sudo apt install -y galculator
sudo apt install -y gimp
sudo apt install -y gnome-bluetooth
sudo apt install -y gnome-shell-extension-manager
sudo apt install -y gnome-software
sudo apt install -y gnome-software-plugin-flatpak
sudo apt install -y gnome-software-snap
sudo apt install -y gnome-tweaks
sudo apt install -y gnome-weather
sudo apt install -y hardinfo
sudo apt install -y hw-probe
sudo apt install -y i3lock-fancy
sudo apt install -y inkscape
sudo apt install -y lollypop
sudo apt install -y lxappearance
sudo apt install -y meld
sudo apt install -y most
sudo apt install -y neofetch
sudo apt install -y nitrogen
sudo apt install -y numlockx
sudo apt install -y obs-studio
sudo apt install -y pavucontrol
sudo apt install -y pylint
sudo apt install -y qbittorrent
sudo apt install -y qt5-style-kvantum
sudo apt install -y qt5-style-kvantum-themes
sudo apt install -y ripgrep
sudo apt install -y scrot
sudo apt install -y simplescreenrecorder
sudo apt install -y speedtest-cli
sudo apt install -y system-config-printer
sudo apt install -y variety
sudo apt install -y virtualbox
sudo apt install -y vlc
sudo apt install -y xfce4-screenshooter

git clone https://github.com/arcolinux/arcolinux-btop /tmp/arcolinux-btop
cp -r /tmp/arcolinux-btop/etc/skel/.config ~

git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~

#if you want to build it you need debhelper and gettext
#rest is on the github of mintstick or use our script or our package
#sudo apt install -y ./mintstick_1.6.2_all.deb
sudo apt install -y mintstick

echo
tput setaf 6
echo "################################################################"
echo "###### Packages via apt install done"
echo "################################################################"
tput sgr0
echo
