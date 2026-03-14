#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/../common" && pwd)"

source "${COMMON_DIR}/common.sh"

echo
tput setaf 2
echo "########################################################################"
echo "################### Install leftwm"
echo "########################################################################"
tput sgr0
echo


list=(
alacritty
archlinux-logout-git
dmenu
edu-leftwm-git
edu-xfce-git
feh
leftwm-git
leftwm-theme-git
lxappearance
noto-fonts
picom-git
polkit-gnome
polybar
rofi
sxhkd
thunar
thunar-archive-plugin
thunar-volman
ttf-fantasque-sans-mono
ttf-hack
ttf-iosevka-nerd
ttf-material-design-iconic-font
ttf-meslo-nerd-font-powerlevel10k
ttf-sourcecodepro-nerd
volctl
xfce4-terminal
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    install_packages $name
done

# when on Leftwm

# if [ -f /usr/share/xsessions/leftwm.desktop ]; then

#     echo
#     tput setaf 2
#     echo "########################################################################"
#     echo "################### Leftwm related applications"
#     echo "########################################################################"
#     tput sgr0
#     echo

# fi

echo
tput setaf 3
echo "########################################################################"
echo "SKEL"
echo "Copying all files and folders from /etc/skel/ to ~"
echo "########################################################################"
tput sgr0
echo

cp -af /etc/skel/.config/leftwm ~/.config/
cp -af /etc/skel/.bin ~

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
