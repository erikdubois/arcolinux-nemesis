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

_install_chadwm=false
_install_ohmychadwm=false

[[ -f "/tmp/install-chadwm" ]] && _install_chadwm=true
[[ -f "/tmp/install-ohmychadwm" ]] && _install_ohmychadwm=true

if ! "$_install_chadwm" && ! "$_install_ohmychadwm"; then
    echo "Neither Chadwm nor Ohmychadwm will be installed. Exiting."
    exit 0
fi

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
echo "################### Installing Chadwm and/or Ohmychadwm ################"
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
echo "###### EDU-POWERMENU"
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

echo
tput setaf 2
echo "########################################################################"
echo "###### CHADWM"
echo "########################################################################"
tput sgr0
echo

if "$_install_chadwm"; then
    # getting the official code from ArcoLinux
    sudo rm -rf /tmp/arcolinux-chadwm
    git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
    sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
    sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
    cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
    cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~
    echo
fi

if "$_install_chadwm"; then
    # overwriting the official code from ArcoLinux with my own
    cp -v run.sh  ~/.config/arco-chadwm/scripts
    #specific picom for Ubuntu
    cp -v picom.conf  ~/.config/arco-chadwm/picom
    cp -v config.def.h ~/.config/arco-chadwm/chadwm
    cp -v sxhkdrc  ~/.config/arco-chadwm/sxhkd
    cp -v bar.sh ~/.config/arco-chadwm/scripts
    [ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
    cp -v uca.xml ~/.config/Thunar/

    cd ~/.config/arco-chadwm/chadwm
    sudo make install
    sudo make clean
fi

echo
tput setaf 2
echo "########################################################################"
echo "###### OHMYCHADWM"
echo "########################################################################"
tput sgr0
echo


if "$_install_ohmychadwm"; then
    # getting the official code
    [ -d /tmp/ohmychadwm ] && rm -rf /tmp/ohmychadwm
    git clone https://github.com/erikdubois/ohmychadwm  /tmp/ohmychadwm
    sudo cp /tmp/ohmychadwm/usr/bin/exec-ohmychadwm /usr/bin
    sudo cp /tmp/ohmychadwm/usr/share/xsessions/ohmychadwm.desktop /usr/share/xsessions
    cp -r /tmp/ohmychadwm/etc/skel/.config ~
    echo
fi

if "$_install_ohmychadwm"; then

    # overwriting the official code
    [ -d $HOME"/.config/ohmychadwm/scripts" ] || mkdir -p $HOME"/.config/ohmychadwm/scripts"
    cp -v "$installed_dir"/ohmychadwm/run.sh  ~/.config/ohmychadwm/scripts
    [ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
    cp -v "$installed_dir"/ohmychadwm/uca.xml ~/.config/Thunar/
    cp -v "$installed_dir"/ohmychadwm/sxhkdrc  ~/.config/ohmychadwm/sxhkd
    cp -v "$installed_dir"/ohmychadwm/alacritty.toml  ~/.config/alacritty
    echo

    echo
    tput setaf 2
    echo "########################################################################"
    echo "###### Building ohmychadwm"
    echo "########################################################################"
    tput sgr0
    echo
    cd ~/.config/ohmychadwm/chadwm
    sudo make install
    sudo make clean

fi

echo
tput setaf 2
echo "########################################################################"
echo "###### ARCHLINUX-LOGOUT-GTK4"
echo "########################################################################"
tput sgr0
echo

[ -d /tmp/archlinux-logout-gtk4 ] && rm -rf /tmp/archlinux-logout-gtk4
git clone https://github.com/erikdubois/archlinux-logout-gtk4 /tmp/archlinux-logout-gtk4

sudo cp /tmp/archlinux-logout-gtk4/usr/bin/archlinux-logout /usr/bin/
sudo cp /tmp/archlinux-logout-gtk4/usr/bin/archlinux-betterlockscreen /usr/bin/
sudo chmod +x /usr/bin/archlinux-logout
sudo chmod +x /usr/bin/archlinux-betterlockscreen

sudo mkdir -p /usr/share/archlinux-logout
sudo cp -r /tmp/archlinux-logout-gtk4/usr/share/archlinux-logout/. /usr/share/archlinux-logout/
sudo mkdir -p /usr/share/archlinux-logout-themes
sudo cp -r /tmp/archlinux-logout-gtk4/usr/share/archlinux-logout-themes/. /usr/share/archlinux-logout-themes/

sudo cp /tmp/archlinux-logout-gtk4/etc/archlinux-logout.conf /etc/


echo
tput setaf 2
echo "########################################################################"
echo "###### VARIETY CONFIG"
echo "########################################################################"
tput sgr0
echo

# getting edu-variety-config
[ -d /tmp/edu-variety-config ] && rm -rf /tmp/edu-variety-config
git clone https://github.com/erikdubois/edu-variety-config  /tmp/edu-variety-config
cp -r /tmp/edu-variety-config/etc/skel/.config ~

echo
tput setaf 2
echo "########################################################################"
echo "###### CLEANING UP"
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
