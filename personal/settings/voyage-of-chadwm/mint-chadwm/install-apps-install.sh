#!/bin/bash
# set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    echo "Debug mode is on. Press Enter to continue..."
    read dummy
    echo
fi

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing packages with apt install"
echo "########################################################################"
tput sgr0
echo

sudo apt install -y apt-file
sudo apt install -y arandr
# on Ubuntu the command is batcat
sudo apt install -y bat
sudo apt install -y btop
sudo apt install -y catfish
sudo apt install -y chromium
sudo apt install -y curl
sudo apt install -y dex
sudo apt install -y dconf-editor
sudo apt install -y duf
sudo apt install -y feh
sudo apt install -y file-roller
sudo apt install -y filezilla
sudo apt install -y flameshot
sudo apt install -y flatpak
sudo apt install -y font-manager
sudo apt install -y fonts-hack
sudo apt install -y fonts-noto
sudo apt install -y fonts-roboto
sudo apt install -y galculator
sudo apt install -y gdm-settings
sudo apt install -y gimp
sudo apt install -y gnome-bluetooth
sudo apt install -y gnome-shell-extension-manager
sudo apt install -y gnome-software
sudo apt install -y gnome-software-plugin-flatpak
sudo apt install -y gnome-software-plugin-snap
sudo apt install -y gnome-tweaks
sudo apt install -y gnome-weather
sudo apt install -y hardinfo
sudo apt install -y hw-probe
sudo apt install -y i3lock-fancy
sudo apt install -y inkscape
sudo apt install -y lolcat
sudo apt install -y lollypop
sudo apt install -y lxappearance
sudo apt install -y meld
sudo apt install -y most
sudo apt install -y neofetch
sudo apt install -y nitrogen
sudo apt install -y nomacs
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
sudo apt install -y vlc
sudo apt install -y xfce4-screenshooter

sudo apt install -y ubuntu-restricted-extras

# getting dot files from Edu nemesis-repo
sudo rm -rf /tmp/edu-dot-files
git clone https://github.com/erikdubois/edu-dot-files /tmp/edu-dot-files
cp -r /tmp/edu-dot-files/etc/skel/.config ~
cp -r /tmp/edu-dot-files/etc/skel/.local ~

# when on real metal install a template
result=$(systemd-detect-virt)
if [ $result = "none" ];then

	sudo apt install -y virtualbox

else

	echo
	tput setaf 3
	echo "#################################################################################"
	echo "### You are on a virtual machine - skipping installation of VirtualBox"
	echo "#################################################################################"
	tput sgr0
	echo

	echo
	tput setaf 2
	echo "########################################################################"
	echo "###### Set resolution on VirtualBox"
	echo "########################################################################"
	tput sgr0
	echo

	# Extract the correct Virtual output (either Virtual-1 or Virtual1)
	VIRTUAL_OUTPUT=$(xrandr | grep -oP '^Virtual-?1(?=\sconnected)')

	# If an output was found, apply xrandr settings
	if [[ -n $VIRTUAL_OUTPUT ]]; then
	    xrandr --output "$VIRTUAL_OUTPUT" --primary --mode 1920x1080 --pos 0x0 --rotate normal
	else
	    echo "No Virtual display found."
	fi

fi

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages via apt install done"
echo "########################################################################"
tput sgr0
echo
