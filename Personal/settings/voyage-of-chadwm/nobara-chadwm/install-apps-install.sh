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
echo "###### Installing packages with apt install"
echo "########################################################################"
tput sgr0
echo

sudo dnf install -y arandr
sudo dnf install -y arc-kde-kvantum
sudo dnf install -y bat
sudo dnf install -y btop
sudo dnf install -y catfish
sudo dnf install -y chromium
sudo dnf install -y curl
sudo dnf install -y dconf-editor
sudo dnf install -y duf
sudo dnf install -y feh
sudo dnf install -y file-roller
sudo dnf install -y flameshot
sudo dnf install -y flatpak
sudo dnf install -y google-roboto-fonts
sudo dnf install -y galculator
sudo dnf install -y gimp
sudo dnf install -y hardinfo
sudo dnf install -y hw-probe
sudo dnf install -y i3lock
sudo dnf install -y inkscape
sudo dnf install -y kvantum-qt5
sudo dnf install -y lollypop
sudo dnf install -y lxappearance
sudo dnf install -y meld
sudo dnf install -y most
sudo dnf install -y neofetch
sudo dnf install -y nitrogen
sudo dnf install -y numlockx
sudo dnf install -y obs-studio
sudo dnf install -y pavucontrol
sudo dnf install -y pylint
sudo dnf install -y qbittorrent
sudo dnf install -y ripgrep
sudo dnf install -y scrot
sudo dnf install -y simplescreenrecorder
sudo dnf install -y speedtest-cli
sudo dnf install -y system-config-printer
sudo dnf install -y variety
sudo dnf install -y VirtualBox
sudo dnf install -y vlc
sudo dnf install -y xfce4-screenshooter

# getting design from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-btop /tmp/arcolinux-btop
cp -r /tmp/arcolinux-btop/etc/skel/.config ~

# getting config for Alacritty - transparency
git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

# script to change wallpaper on Chadwm
git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages via apt install done"
echo "########################################################################"
tput sgr0
echo
