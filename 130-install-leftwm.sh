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
tput setaf 3
echo "################################################################"
echo "################### Leftwm"
echo "################################################################"
tput sgr0
echo

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}

echo
tput setaf 2
echo "################################################################"
echo "################### Install leftwm"
echo "################################################################"
tput sgr0
echo


list=(
edu-leftwm-git
leftwm-dev-git
leftwm-theme-git
lxappearance
picom
polybar
rofi-theme-fonts
sxhkd
ttf-fantasque-sans-mono
ttf-iosevka-nerd
ttf-material-design-iconic-font
ttf-meslo-nerd-font-powerlevel10k
ttf-sourcecodepro-nerd
volumeicon
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    func_install $name
done

# when on Leftwm

if [ -f /usr/share/xsessions/leftwm.desktop ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Leftwm related applications"
    echo "################################################################"
    tput sgr0
    echo

    #cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
    #cp -arf /etc/skel/.config/leftwm $HOME/.config

    #sh ~/.config/leftwm/scripts/install-all-arcolinux-themes.sh
    #sh ~/.config/leftwm/scripts/install-all-arcolinux-community-themes.sh

    #leftwm-theme update
    #leftwm-theme apply db-nemesis

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo
