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
echo "################### Installing Chadwm"
echo "########################################################################"
tput sgr0
echo

# https://sysadminsage.com/ubuntu-remove-a-package/

#echo
#tput setaf 1
#echo "########################################################################"
#echo "################### This will remove the Ubuntu desktop"
#echo "################### The following packages will be removed:"
#echo "################### - ubuntu-desktop-minimal"
#echo "################### - ubuntu-session-xsession"
#echo "################### - ubuntu-session"
#echo "################### - xdg-desktop-portal-gnome"
#echo "########################################################################"
#tput sgr0
#echo

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

echo
tput setaf 2
echo "########################################################################"
echo "###### Git cloning"
echo "########################################################################"
tput sgr0
echo

# exit strategy - super + shift + x
sudo rm -rf /tmp/arcolinux-powermenu
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~
echo

# getting the official code from ArcoLinux
sudo rm -rf /tmp/arcolinux-chadwm
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~
echo

echo
tput setaf 2
echo "########################################################################"
echo "###### Overwriting official code with personal code"
echo "########################################################################"
tput sgr0
echo

# overwriting the official code from ArcoLinux with my own
cp -v run.sh  ~/.config/arco-chadwm/scripts
#specific picom for Ubuntu
cp -v picom.conf  ~/.config/arco-chadwm/picom
cp -v config.def.h ~/.config/arco-chadwm/chadwm
cp -v sxhkdrc  ~/.config/arco-chadwm/sxhkd
cp -v bar.sh ~/.config/arco-chadwm/scripts
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp -v uca.xml ~/.config/Thunar/
echo
echo

cd ~/.config/arco-chadwm/chadwm
sudo make install

echo
tput setaf 2
echo "########################################################################"
echo "###### Cleanup"
echo "########################################################################"
tput sgr0
echo

# removing this package - it slows down terminals and thunar
# this will remove the complete ubuntu desktop in 24.10 not in 24.04
sudo apt remove -y xdg-desktop-portal-gnome

sudo apt autoremove -y

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

echo
tput setaf 6
echo "########################################################################"
echo "###### Chadwm is installed"
echo "########################################################################"
tput sgr0
echo
