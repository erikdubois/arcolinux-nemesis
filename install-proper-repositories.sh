#!/bin/bash
#set -e
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

#end colors
#tput sgr0
##################################################################################################################################

#networkmanager issue
#nmcli connection modify Wired\ connection\ 1 ipv6.method "disabled"

# what is the present working directory
installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

# set DEBUG to true to be able to analyze the scripts file per file
export DEBUG=false

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

if ! grep -q -e "Manjaro" -e "Artix" /etc/os-release; then

  echo "Deleting current /etc/pacman.d/mirrorlist and replacing with"
  echo
echo "## Best Arch Linux servers worldwide from arcolinux-nemesis

Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = http://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch"  | sudo tee /etc/pacman.d/mirrorlist
  echo
fi

tput setaf 2
echo "################################################################################"
echo "Arch Linux Servers have been written to /etc/pacman.d/mirrorlist"
echo "Use nmirrorlist when on ArcoLinux to inspect"
echo "################################################################################"
tput sgr0
echo

# Installing chaotic-aur keys and mirrors
pkg_dir="packages"

# Ensure directory exists
if [[ ! -d "$pkg_dir" ]]; then
    echo "Directory not found: $pkg_dir"
    exit 1
fi

# Install all local packages using pacman
find "$pkg_dir" -maxdepth 1 -name '*.pkg.tar.zst' -print0 | sudo xargs -0 pacman -U --noconfirm


# personal pacman.conf for Erik Dubois
if [[ ! -f /etc/pacman.conf.nemesis ]]; then
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Copying /etc/pacman.conf to /etc/pacman.conf.nemesis"
    echo "Use npacman when on ArcoLinux to inspect"
    echo "################################################################################"
    tput sgr0
    echo
    sudo cp -v /etc/pacman.conf /etc/pacman.conf.nemesis
    echo
else
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Backup already exists: /etc/pacman.conf.nemesis"
    echo "Use npacman when on ArcoLinux to inspect"
    echo "################################################################################"
    tput sgr0
    echo
fi

sudo cp -v pacman.conf /etc/pacman.conf

echo
tput setaf 2
echo "################################################################################"
echo "Updating the system - sudo pacman -Syyu"
echo "################################################################################"
tput sgr0
echo

sudo pacman -Syyu --noconfirm

tput setaf 3
echo "########################################################################"
echo "End"
echo "########################################################################"
tput sgr0
