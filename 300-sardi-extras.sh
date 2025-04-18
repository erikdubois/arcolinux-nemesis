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
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

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

echo
tput setaf 2
echo "########################################################################"
echo "################### Installing software from nemesis_repo"
echo "########################################################################"
tput sgr0
echo

# Define your package list
packages=(
sardi-icons
sardi-colora-variations-icons-git
sardi-flat-colora-variations-icons-git
sardi-flat-mint-y-icons-git
sardi-flat-mixing-icons-git
sardi-flexible-colora-variations-icons-git
sardi-flexible-luv-colora-variations-icons-git
sardi-flexible-mint-y-icons-git
sardi-flexible-mixing-icons-git
sardi-flexible-variations-icons-git
sardi-ghost-flexible-colora-variations-icons-git
sardi-ghost-flexible-mint-y-icons-git
sardi-ghost-flexible-mixing-icons-git
sardi-ghost-flexible-variations-icons-git
sardi-mint-y-icons-git
sardi-mixing-icons-git
sardi-mono-colora-variations-icons-git
sardi-mono-mint-y-icons-git
sardi-mono-mixing-icons-git
sardi-mono-numix-colora-variations-icons-git
sardi-mono-papirus-colora-variations-icons-git
sardi-orb-colora-mint-y-icons-git
sardi-orb-colora-mixing-icons-git
sardi-orb-colora-variations-icons-git
)

# Install packages
for pkg in "${packages[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "✔ $pkg is already installed."
    else
        echo "➤ Installing $pkg..."
        sudo pacman -S --noconfirm --needed "$pkg"
    fi
done


echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo