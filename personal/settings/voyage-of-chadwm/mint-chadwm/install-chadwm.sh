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
sudo rm -rf /tmp/edu-powermenu
git clone https://github.com/erikdubois/edu-powermenu  /tmp/edu-powermenu
sudo cp /tmp/edu-powermenu/usr/local/bin/edu-powermenu /usr/local/bin
cp -r /tmp/edu-powermenu/etc/skel/.bin ~
cp -r /tmp/edu-powermenu/etc/skel/.config ~
echo

if "$_install_chadwm"; then
    # getting the official code from Edu-chadwm
    [ -d /tmp/edu-chadwm ] && rm -rf /tmp/edu-chadwm
    git clone https://github.com/erikdubois/edu-chadwm  /tmp/edu-chadwm
    sudo cp /tmp/edu-chadwm/usr/bin/exec-chadwm /usr/bin
    sudo cp /tmp/edu-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
    cp -r /tmp/edu-chadwm/etc/skel/.bin ~
    cp -r /tmp/edu-chadwm/etc/skel/.config ~
    echo
fi

if "$_install_ohmychadwm"; then
    # getting the official code
    [ -d /tmp/ohmychadwm ] && rm -rf /tmp/ohmychadwm
    git clone https://github.com/erikdubois/ohmychadwm  /tmp/ohmychadwm
    sudo cp /tmp/ohmychadwm/usr/bin/exec-ohmychadwm /usr/bin
    sudo cp /tmp/ohmychadwm/usr/share/xsessions/ohmychadwm.desktop /usr/share/xsessions
    cp -r /tmp/ohmychadwm/etc/skel/.bin ~
    cp -r /tmp/ohmychadwm/etc/skel/.config ~
    echo
fi

if "$_install_chadwm"; then
    echo
    tput setaf 2
    echo "########################################################################"
    echo "###### Overwriting official code with personal code"
    echo "########################################################################"
    tput sgr0
    echo

    # overwriting the official code from ArcoLinux with my own
    cp -v arco-chadwm/run.sh  ~/.config/arco-chadwm/scripts
    cp -v arco-chadwm/picom.conf  ~/.config/arco-chadwm/picom
    cp -v arco-chadwm/config.def.h ~/.config/arco-chadwm/chadwm
    cp -v arco-chadwm/sxhkdrc  ~/.config/arco-chadwm/sxhkd
    cp -v arco-chadwm/bar.sh ~/.config/arco-chadwm/scripts
    [ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
    cp -v arco-chadwm/uca.xml ~/.config/Thunar/
    echo
fi



if "$_install_chadwm"; then
    echo
    tput setaf 2
    echo "########################################################################"
    echo "###### Building chadwm"
    echo "########################################################################"
    tput sgr0
    echo
    cd ~/.config/arco-chadwm/chadwm
    sudo make install
    sudo make clean
fi

if "$_install_ohmychadwm"; then
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

    # overwriting the official code
    cp -v ohmychadwm/run.sh  ~/.config/ohmychadwm/scripts
    cp -v ohmychadwm/picom.conf  ~/.config/ohmychadwm/picom
    cp -v ohmychadwm/config.def.h ~/.config/ohmychadwm/chadwm
    cp -v ohmychadwm/sxhkdrc  ~/.config/ohmychadwm/sxhkd
    cp -v ohmychadwm/bar.sh ~/.config/ohmychadwm/scripts
    [ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
    cp -v ohmychadwm/uca.xml ~/.config/Thunar/
    echo
fi

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing archlinux-logout-gtk4"
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


# getting edu-variety-config
[ -d /tmp/edu-variety-config ] && rm -rf /tmp/edu-variety-config
git clone https://github.com/erikdubois/edu-variety-config  /tmp/edu-variety-config
cp -r /tmp/edu-variety-config/etc/skel/.config ~

echo
tput setaf 2
echo "########################################################################"
echo "###### Cleanup"
echo "########################################################################"
tput sgr0
echo

# removing this package - it slows down terminals and thunar
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
