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
echo "###### Installing packages with xbps-install"
echo "########################################################################"
tput sgr0
echo

sudo xbps-install --yes alacritty
sudo xbps-install --yes arandr
sudo xbps-install --yes avahi
sudo xbps-install --yes base-devel
sudo xbps-install --yes bat
sudo xbps-install --yes btop
sudo xbps-install --yes catfish
#sudo xbps-install --yes chromium-browser
sudo xbps-install --yes curl
sudo xbps-install --yes dex
sudo xbps-install --yes dconf-editor
sudo xbps-install --yes dmenu
sudo xbps-install --yes duf
sudo xbps-install --yes feh
sudo xbps-install --yes file-roller
sudo xbps-install --yes filezilla
sudo xbps-install --yes fish-shell
sudo xbps-install --yes flameshot
sudo xbps-install --yes flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo xbps-install --yes fontmanager
sudo xbps-install --yes fonts-roboto-ttf
sudo xbps-install --yes galculator
sudo xbps-install --yes gdm-settings
sudo xbps-install --yes gimp
sudo xbps-install --yes gnome-bluetooth
#sudo xbps-install --yes gnome-shell-extension-manager
sudo xbps-install --yes gnome-software
#sudo xbps-install --yes gnome-software-plugin-flatpak
#sudo xbps-install --yes gnome-software-plugin-snap
sudo xbps-install --yes gnome-tweaks
sudo xbps-install --yes gnome-weather
sudo xbps-install --yes google-fonts-ttf
sudo xbps-install --yes hardinfo
sudo xbps-install --yes hwinfo
#sudo xbps-install --yes hw-probe
sudo xbps-install --yes i3lock-fancy
sudo xbps-install --yes inkscape
sudo xbps-install --yes lolcat-c
sudo xbps-install --yes lollypop
sudo xbps-install --yes lxappearance
sudo xbps-install --yes meld
sudo xbps-install --yes most
sudo xbps-install --yes nano
sudo xbps-install --yes neofetch
sudo xbps-install --yes nitrogen
sudo xbps-install --yes nomacs
sudo xbps-install --yes numlockx
sudo xbps-install --yes obs
sudo xbps-install --yes pavucontrol
sudo xbps-install --yes polkit-gnome
sudo xbps-install --yes pylint
sudo xbps-install --yes qbittorrent
#sudo xbps-install --yes qt5-style-kvantum
#sudo xbps-install --yes qt5-style-kvantum-themes
sudo xbps-install --yes ripgrep
sudo xbps-install --yes scrot
#sudo xbps-install --yes simplescreenrecorder
sudo xbps-install --yes speedtest-cli
sudo xbps-install --yes system-config-printer
sudo xbps-install --yes variety
sudo xbps-install --yes virt-what
sudo xbps-install --yes vlc
sudo xbps-install --yes wget
sudo xbps-install --yes xfce4-screenshooter
sudo xbps-install --yes xfce4-whiskermenu-plugin

# getting design from ArcoLinux
folder="/tmp/arcolinux-btop"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-btop /tmp/arcolinux-btop
cp -r /tmp/arcolinux-btop/etc/skel/.config ~

# getting config for Alacritty - transparency
folder="/tmp/arcolinux-alacritty"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

# script to change wallpaper on Chadwm
folder="/tmp/arcolinux-variety"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~


# when on real metal install a template
result=$(sudo virt-what)
if [ $result != "kvm" ];then

	sudo xbps-install --yes virtualbox

else

	echo
	tput setaf 3
	echo "#################################################################################"
	echo "### You are on a virtual machine - skipping installation of VirtualBox"
	echo "#################################################################################"
	tput sgr0
	echo

	xrandr --output Virtual1 --primary --mode 1920x1080 --pos 0x0 --rotate normal

fi

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages via xbps-install done"
echo "########################################################################"
tput sgr0
echo
