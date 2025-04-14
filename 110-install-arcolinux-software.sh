#!/bin/bash
#set -e
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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### ArcoLinux Software to install"
echo "################################################################"
tput sgr0
echo

# Function to check if a package is installed
is_installed() {
    pacman -Q "$1" &> /dev/null
    return $?
}

# Function to remove a package
remove_package() {
    local package=$1
    echo "Attempting to remove package: $package"
    sudo pacman -R --noconfirm "$package"
    if [ $? -eq 0 ]; then
        echo "Package '$package' has been removed successfully."
    else
        echo "Failed to remove package '$package'."
    fi
}

echo
tput setaf 2
echo "################################################################"
echo "################### Getting dev versions"
echo "################################################################"
tput sgr0
echo

PACKAGE="archlinux-kernel-manager"

# Main logic
if is_installed "$PACKAGE"; then
    echo "Package '$PACKAGE' is installed."
    remove_package "$PACKAGE"
else
    echo "Package '$PACKAGE' is not installed. No action taken."
fi

PACKAGE="archlinux-tweak-tool-git"

# Main logic
if is_installed "$PACKAGE"; then
    echo "Package '$PACKAGE' is installed."
    remove_package "$PACKAGE"
else
    echo "Package '$PACKAGE' is not installed. No action taken."
fi

PACKAGE="sofirem-git"

# Main logic
if is_installed "$PACKAGE"; then
    echo "Package '$PACKAGE' is installed."
    remove_package "$PACKAGE"
else
    echo "Package '$PACKAGE' is not installed. No action taken."
fi

PACKAGE="arcolinux-app-glade-git"

# Main logic
if is_installed "$PACKAGE"; then
    echo "Package '$PACKAGE' is installed."
    remove_package "$PACKAGE"
else
    echo "Package '$PACKAGE' is not installed. No action taken."
fi

sudo pacman -S --noconfirm --needed archlinux-kernel-manager-dev
sudo pacman -S --noconfirm --needed archlinux-tweak-tool-dev-git
sudo pacman -S --noconfirm --needed sofirem-dev-git
sudo pacman -S --noconfirm --needed arcolinux-app-glade-dev-git

sudo pacman -S --noconfirm --needed neo-candy-icons-git
sudo pacman -S --noconfirm --needed arcolinux-fastfetch-git
sudo pacman -S --noconfirm --needed arcolinux-hblock-git
sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git

if [ -d "/etc/skel/.config/variety/" ]; then
    echo "Directory exists. Removing..."
    sudo rm -r /etc/skel/.config/variety/
    echo "Directory removed."
else
    echo "Directory does not exist."
fi

sudo pacman -S --noconfirm arconet-variety-config
mkdir -p ~/.config/variety
cp -rv /etc/skel/.config/variety ~/.config/

# setting my personal configuration for variety
echo "getting latest variety config from github"
sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf

if [ ! -f /usr/share/wayland-sessions/plasma.desktop ]; then
  sudo pacman -S --noconfirm --needed archlinux-logout-git
  sudo pacman -S --noconfirm --needed arcolinux-arc-dawn-git
fi

###############################################################################

# when on Plasma X11

if [ -f /usr/bin/startplasma-x11 ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma X11 related applications"
  echo "################################################################"
  tput sgr0
  echo

  #sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
  #sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
  #sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
  #sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git
fi

# when on Plasma Wayland

if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma wayland related applications"
  echo "################################################################"
  tput sgr0
  echo
  sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
  sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git
fi


if [ -f /usr/share/xsessions/xfce.desktop ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Installing software for Xfce"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed arcolinux-arc-kde

fi

if [ -f /usr/share/xsessions/cinnamon.desktop ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Installing software for Cinnamon"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed nemo-fileroller
  sudo pacman -S --noconfirm --needed cinnamon-translations
  sudo pacman -S --noconfirm --needed mintlocale
  sudo pacman -S --noconfirm --needed iso-flag-png
  sudo pacman -S --noconfirm --needed gnome-terminal
  sudo pacman -S --noconfirm --needed gnome-system-monitor
  sudo pacman -S --noconfirm --needed gnome-screenshot
  sudo pacman -S --noconfirm --needed xed

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo