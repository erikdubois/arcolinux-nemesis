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
echo "################### Install awesome"
echo "########################################################################"
tput sgr0
echo


list=(
alacritty
archlinux-logout-git
awesome
dmenu
edu-awesome-git
edu-xfce-git
feh
lxappearance
noto-fonts
picom-git
polkit-gnome
rofi
thunar
thunar-archive-plugin
thunar-volman
ttf-hack
vicious
volctl
xfce4-terminal
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    install_packages $name
done

echo
tput setaf 3
echo "########################################################################"
echo "SKEL"
echo "Copying all files and folders from /etc/skel/ to ~"
echo "########################################################################"
tput sgr0
echo

cp -af /etc/skel/.config/awesome ~/.config/

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
