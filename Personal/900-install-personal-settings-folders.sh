#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Personal settings to install"
echo "################################################################"
tput sgr0
echo
echo "Creating folders we use later"
echo
[ -d $HOME"/.bin" ] || mkdir -p $HOME"/.bin"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.local/share/icons" ] || mkdir -p $HOME"/.local/share/icons"
[ -d $HOME"/.local/share/themes" ] || mkdir -p $HOME"/.local/share/themes"
[ -d "/personal" ] || mkdir -p "/personal"
[ -d $HOME"/.config" ] || mkdir -p $HOME"/.config"
[ -d $HOME"/.config/fish" ] || mkdir -p $HOME"/.config/fish"
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
echo
echo "Installing all shell files"
echo
installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
cp $installed_dir/settings/shell-personal/.bashrc-personal ~
cp $installed_dir/settings/shell-personal/.zshrc ~
cp $installed_dir/settings/shell-personal/.zshrc-personal ~
cp $installed_dir/settings/fish/alias.fish ~/.config/fish/alias.fish
echo
echo "Installing personal settings of variety"
echo
[ -d $HOME"/.config/variety" ] || mkdir -p $HOME"/.config/variety"
cp $installed_dir/settings/variety/variety.conf ~/.config/variety/
echo
echo "Installing screenkey for teaching"
echo
cp $installed_dir/settings/screenkey/screenkey.json ~/.config/
echo
echo "Adding personal looks to /personal"
echo
[ -d /personal ] || mkdir -p /personal
sudo cp -arf ../Personal-iso/personal-iso/* /personal
echo
echo "Adding personal thunar to .config/thunar"
echo
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp  settings/thunar/uca.xml $HOME/.config/Thunar
echo
echo "Copy paste virtual box template"
echo
[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
sudo cp -rf settings/virtualbox-template/* ~/VirtualBox\ VMs/
cd ~/VirtualBox\ VMs/
tar -xzf template.tar.gz
rm -f template.tar.gz

echo
tput setaf 2
echo "################################################################"
echo "################### Personal settings installed"
echo "################################################################"
tput sgr0
echo