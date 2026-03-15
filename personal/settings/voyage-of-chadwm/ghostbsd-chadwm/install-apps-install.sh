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
echo "###### Installing packages with pkg install"
echo "########################################################################"
tput sgr0
echo

sudo pkg install -y arandr
sudo pkg install -y bat
sudo pkg install -y btop
sudo pkg install -y catfish
sudo pkg install -y chromium
sudo pkg install -y curl
sudo pkg install -y dconf-editor
sudo pkg install -y duf
sudo pkg install -y feh
sudo pkg install -y file-roller
sudo pkg install -y filezilla
sudo pkg install -y firefox
sudo pkg install -y flameshot
sudo pkg install -y font-manager
sudo pkg install -y hack-font
sudo pkg install -y noto
sudo pkg install -y roboto-fonts-ttf
sudo pkg install -y galculator
sudo pkg install -y gimp
sudo pkg install -y gnome-tweaks
sudo pkg install -y gnome-weather
sudo pkg install -y hw-probe
sudo pkg install -y inkscape
sudo pkg install -y kvantum
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
sudo pkg install -y pidof
sudo pkg install -y qbittorrent
sudo pkg install -y qt5ct
sudo pkg install -y ripgrep
sudo pkg install -y telegram-desktop
sudo pkg install -y scrot
sudo pkg install -y simplescreenrecorder
sudo pkg install -y linux-sublime-text4
sudo pkg install -y system-config-printer
sudo pkg install -y variety
sudo pkg install -y vlc
sudo pkg install -y wget
sudo pkg install -y xfce4-screenshooter-plugin
sudo pkg install -y xdg-user-dirs

xdg-user-dirs-update

echo
tput setaf 6
echo "########################################################################"
echo "###### ArcoLinux settings for btop"
echo "########################################################################"
tput sgr0
echo

# getting design from ArcoLinux
folder="/tmp/arcolinux-btop"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-btop /tmp/arcolinux-btop
cp -r /tmp/arcolinux-btop/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### ArcoLinux settings for alacritty"
echo "########################################################################"
tput sgr0
echo

# getting config for Alacritty - transparency
folder="/tmp/arcolinux-alacritty"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-alacritty /tmp/arcolinux-alacritty
cp -r /tmp/arcolinux-alacritty/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### ArcoLinux settings for variety"
echo "########################################################################"
tput sgr0
echo

# script to change wallpaper on Chadwm
folder="/tmp/arcolinux-variety"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-variety /tmp/arcolinux-variety
cp -r /tmp/arcolinux-variety/etc/skel/.config ~

echo
tput setaf 6
echo "########################################################################"
echo "###### Install virtualbox or not"
echo "########################################################################"
tput sgr0
echo

# Check system hardware information
hw_machine=$(sysctl -n hw.machine)
hw_model=$(sysctl -n hw.model)

# Function to check for virtualization keywords
is_virtual_machine() {
    case "$hw_model" in
        *"VirtualBox"*) return 0 ;;
        *"QEMU"*) return 0 ;;
        *"KVM"*) return 0 ;;
        *"VMware"*) return 0 ;;
        *"Hyper-V"*) return 0 ;;
        *) return 1 ;;
    esac
}

# Perform actions based on whether it's a VM
if is_virtual_machine; then
	echo
	tput setaf 3
	echo "#################################################################################"
	echo "### You are on a virtual machine - skipping installation of VirtualBox"
	echo "#################################################################################"
	tput sgr0
	echo

	xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
else
    echo
	tput setaf 3
	echo "#################################################################################"
	echo "### NOT running in a virtual machine - installing VirtualBox"
	echo "#################################################################################"
	tput sgr0
	echo
    sudo pkg install -y virtualbox-ose
fi

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages via pkg install done"
echo "########################################################################"
tput sgr0
echo
