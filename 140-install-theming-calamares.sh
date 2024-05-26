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
echo "################### All themes from Calamares"
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
echo "####  Install all themes, icons and cursors from Calamares"
echo "################################################################"
tput sgr0
echo


list=(
adapta-gtk-theme
arcolinux-arc-themes-2021-git
arcolinux-arc-themes-2021-sky-git
arcolinux-arc-themes-2021-creative-git
ayu-theme
breeze
dracula-gtk-theme
fluent-gtk-theme
fluent-kde-theme-git
graphite-gtk-theme-git
kripton-theme-git
kvantum-theme-materia
kvantum-theme-qogir-git
layan-gtk-theme-git
layan-kde-git
materia-gtk-theme
materia-kde
numix-gtk-theme-git
openbox-themes-pambudi-git
orchis-kde-theme-git
orchis-theme-git
qogir-gtk-theme-git
sweet-theme-git
sweet-gtk-theme
arc-icon-theme
a-candy-beauty-icon-theme-git
breeze
dracula-icons-git
faba-icon-theme-git
faba-mono-icons-git
flat-remix-git
fluent-icon-theme-git
halo-icons-git
la-capitaine-icon-theme-git
luna-icon-theme-git
moka-icon-theme-git
nordzy-icon-theme-git
numix-circle-arc-icons-git
numix-circle-icon-theme-git
obsidian-icon-theme
oranchelo-icon-theme-git
paper-icon-theme
papirus-folders-git
papirus-folders-gui-bin
papirus-folders-nordic
papirus-icon-theme
papirus-nord
qogir-icon-theme
surfn-mint-y-icons-git
tela-circle-icon-theme-git
vimix-icon-theme-git
we10x-icon-theme-git
whitesur-icon-theme-git
zafiro-icon-theme
bibata-cursor-translucent
bibata-extra-cursor-theme
bibata-rainbow-cursor-theme
capitaine-cursors
catppuccin-cursors-git
dracula-cursors-git
layan-cursor-theme-git
oxy-neon
sweet-cursor-theme-git
xcursor-arch-cursor-complete
xcursor-breeze
xcursor-comix
xcursor-flatbed
xcursor-neutral
xcursor-premium
xcursor-simpleandsoft
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

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    func_install $name
done

echo
tput setaf 2
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo




# - name: "Themes"
#   description: "Themes"
#   critical: false
#   hidden: false
#   selected: false
#   expanded: true
#   packages:
#     - adapta-gtk-theme
#     - arcolinux-arc-kde
#    - arcolinux-arc-themes-2021-git
#    - arcolinux-arc-themes-2021-sky-git
#    - arcolinux-arc-themes-2021-creative-git
#     - arcolinux-sweet-mars-git
#     - ayu-theme
#     - breeze
#     - dracula-gtk-theme
#     - fluent-gtk-theme
#     - fluent-kde-theme-git
#     - graphite-gtk-theme-git
#     - kripton-theme-git
#     - kvantum-theme-materia
#     - kvantum-theme-qogir-git
#     - layan-gtk-theme-git
#     - layan-kde-git
#     - materia-gtk-theme
#     - materia-kde
#     - numix-gtk-theme-git
#     - openbox-themes-pambudi-git
#     - orchis-kde-theme-git
#     - orchis-theme-git
#     - qogir-gtk-theme-git
#     - sweet-theme-git
#     - sweet-gtk-theme-dark
# - name: "Icons"
#   description: "Icons"
#   critical: false
#   hidden: false
#   selected: false
#   expanded: true
#   packages:
#     - arc-icon-theme
#     - a-candy-beauty-icon-theme-git
#     - breeze
#     - dracula-icons-git
#     - faba-icon-theme-git
#     - faba-mono-icons-git
#     - flat-remix-git
#     - fluent-icon-theme-git
#     - halo-icons-git
#     - la-capitaine-icon-theme-git
#     - luna-icon-theme-git
#     - moka-icon-theme-git
#     - nordzy-icon-theme-git
#     - numix-circle-arc-icons-git
#     - numix-circle-icon-theme-git
#     - obsidian-icon-theme
#     - oranchelo-icon-theme-git
#     - paper-icon-theme
#     - papirus-folders-git
#     - papirus-folders-gui-bin
#     - papirus-folders-nordic
#     - papirus-icon-theme
#     - papirus-nord
#     - qogir-icon-theme
#     - surfn-mint-y-icons-git
#     - tela-circle-icon-theme-git
#     - vimix-icon-theme-git
#     - we10x-icon-theme-git
#     - whitesur-icon-theme-git
#     - zafiro-icon-theme
# - name: "Cursors"
#   description: "Cursors"
#   critical: false
#   hidden: false
#   selected: false
#   expanded: true
#   packages:
#     - bibata-cursor-translucent
#     - bibata-extra-cursor-theme
#     - bibata-rainbow-cursor-theme
#     - capitaine-cursors
#     - catppuccin-cursors-git
#     - dracula-cursors-git
#     - layan-cursor-theme-git
#     - oxy-neon
#     - sweet-cursor-theme-git
#     - xcursor-arch-cursor-complete
#     - xcursor-breeze
#     - xcursor-comix
#     - xcursor-flatbed
#     - xcursor-neutral
#     - xcursor-premium
#     - xcursor-simpleandsoft
# - name: "Sardi icons"
#   description: "Sardi icons"
#   critical: false
#   hidden: false
#   selected: false
#   expanded: true
#   packages:
#     - sardi-colora-variations-icons-git
#     - sardi-flat-colora-variations-icons-git
#     - sardi-flat-mint-y-icons-git
#     - sardi-flat-mixing-icons-git
#     - sardi-flexible-colora-variations-icons-git
#     - sardi-flexible-luv-colora-variations-icons-git
#     - sardi-flexible-mint-y-icons-git
#     - sardi-flexible-mixing-icons-git
#     - sardi-flexible-variations-icons-git
#     - sardi-ghost-flexible-colora-variations-icons-git
#     - sardi-ghost-flexible-mint-y-icons-git
#     - sardi-ghost-flexible-mixing-icons-git
#     - sardi-ghost-flexible-variations-icons-git
#     - sardi-mint-y-icons-git
#     - sardi-mixing-icons-git
#     - sardi-mono-colora-variations-icons-git
#     - sardi-mono-mint-y-icons-git
#     - sardi-mono-mixing-icons-git
#     - sardi-mono-numix-colora-variations-icons-git
#     - sardi-mono-papirus-colora-variations-icons-git
#     - sardi-orb-colora-mint-y-icons-git
#     - sardi-orb-colora-mixing-icons-git
#     - sardi-orb-colora-variations-icons-git

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo