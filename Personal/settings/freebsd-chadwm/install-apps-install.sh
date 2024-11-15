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
echo "###### Installing packages with pkg install"
echo "################################################################"
tput sgr0
echo

sudo pkg install -y arandr
# on Ubuntu the command is batcat
sudo pkg install -y bat
sudo pkg install -y btop
sudo pkg install -y catfish
#sudo pkg install -y chromium-browser
sudo pkg install -y curl
sudo pkg install -y dex
sudo pkg install -y dconf-editor
sudo pkg install -y duf
sudo pkg install -y feh
sudo pkg install -y file-roller
sudo pkg install -y filezilla
sudo pkg install -y flameshot
sudo pkg install -y flatpak
sudo pkg install -y font-manager
sudo pkg install -y fonts-hack
sudo pkg install -y fonts-noto
sudo pkg install -y fonts-roboto
sudo pkg install -y galculator
sudo pkg install -y gdm-settings
sudo pkg install -y gimp
sudo pkg install -y gnome-bluetooth
sudo pkg install -y gnome-shell-extension-manager
sudo pkg install -y gnome-software
sudo pkg install -y gnome-software-plugin-flatpak
sudo pkg install -y gnome-software-plugin-snap
sudo pkg install -y gnome-tweaks
sudo pkg install -y gnome-weather
sudo pkg install -y hardinfo
sudo pkg install -y hw-probe
sudo pkg install -y i3lock-fancy
sudo pkg install -y inkscape
sudo pkg install -y lolcat
sudo pkg install -y lollypop
sudo pkg install -y lxappearance
sudo pkg install -y meld
sudo pkg install -y most
sudo pkg install -y neofetch
sudo pkg install -y nitrogen
sudo pkg install -y nomacs
sudo pkg install -y numlockx
sudo pkg install -y obs-studio
sudo pkg install -y pavucontrol
sudo pkg install -y pylint
sudo pkg install -y qbittorrent
sudo pkg install -y qt5-style-kvantum
sudo pkg install -y qt5-style-kvantum-themes
sudo pkg install -y ripgrep
sudo pkg install -y scrot
sudo pkg install -y simplescreenrecorder
sudo pkg install -y speedtest-cli
sudo pkg install -y system-config-printer
sudo pkg install -y variety
sudo pkg install -y vlc
sudo pkg install -y xfce4-screenshooter

# getting design from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-btop /tmp/arcolinux-btop
cp -r /tmp/arcolinux-btop/etc/skel/.config ~

# getting config for Alacritty - transparency
git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

# script to change wallpaper on Chadwm
git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~


# when on real metal install a template
result=$(systemd-detect-virt)
if [ $result = "none" ];then

	sudo pkg install -y virtualbox

else

	echo
	tput setaf 3
	echo "#########################################################################"
	echo "### You are on a virtual machine - skipping installation of VirtualBox"
	echo "#########################################################################"
	tput sgr0
	echo

	xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal

fi



echo
tput setaf 6
echo "################################################################"
echo "###### Packages via pkg install done"
echo "################################################################"
tput sgr0
echo
