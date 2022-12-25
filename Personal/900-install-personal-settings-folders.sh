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
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.local/share/icons" ] || mkdir -p $HOME"/.local/share/icons"
[ -d $HOME"/.local/share/themes" ] || mkdir -p $HOME"/.local/share/themes"
[ -d "/personal" ] || sudo mkdir -p "/personal"
[ -d $HOME"/.config" ] || mkdir -p $HOME"/.config"
[ -d $HOME"/.config/fish" ] || mkdir -p $HOME"/.config/fish"
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
echo
echo "Installing all shell files"
echo
cp $installed_dir/settings/shell-personal/.bashrc-personal ~
cp $installed_dir/settings/shell-personal/.zshrc ~
sudo cp $installed_dir/settings/shell-personal/.zshrc /etc/skel/~
cp $installed_dir/settings/shell-personal/.zshrc-personal ~
cp $installed_dir/settings/fish/alias.fish ~/.config/fish/alias.fish
echo
echo "Installing personal settings of variety"
echo
[ -d $HOME"/.config/variety" ] || mkdir -p $HOME"/.config/variety"
cp $installed_dir/settings/variety/variety.conf ~/.config/variety/
sudo cp $installed_dir/settings/variety/variety.conf /etc/skel/.config/variety/
echo
echo "Installing screenkey for teaching"
echo
cp $installed_dir/settings/screenkey/screenkey.json ~/.config/
echo
echo "Adding personal looks to /personal"
echo
sudo cp -arf ../Personal-iso/personal-iso/* /personal
echo
echo "Adding personal thunar to .config/thunar"
echo
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp  $installed_dir/settings/thunar/uca.xml $HOME/.config/Thunar
sudo cp  $installed_dir/settings/thunar/uca.xml /etc/skel/.config/Thunar
echo
echo "Adding xfce settings"
/home/erik/ARCO/ARCOLINUX-DESKTOP/arcolinux-xfce/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
echo
[ -d $HOME"/.config/xfce4/xfconf/xfce-perchannel-xml/" ] || mkdir -p $HOME"/.config/xfce4/xfconf/xfce-perchannel-xml/"
cp  $installed_dir/settings/xfce/xsettings.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
sudo cp  $installed_dir/settings/xfce/xsettings.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
echo
echo "Adding gtk-3.0 config"
echo
[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
cp  $installed_dir/settings/gtk3/settings.ini $HOME/.config/gtk-3.0
sudo cp  $installed_dir/settings/gtk3/settings.ini /etc/skel/.config/gtk-3.0
echo
echo "Adding personal neofetch"
echo
[ -d $HOME"/.config/neofetch" ] || mkdir -p $HOME"/.config/neofetch"
cp  $installed_dir/settings/neofetch/config.conf $HOME/.config/neofetch/
sudo cp  $installed_dir/settings/neofetch/config.conf /etc/skel/.config/neofetch/

echo
echo "Adding xorg xkill"
echo
[ -d /etc/X11/xorg.conf.d/ ] || mkdir -p /etc/X11/xorg.conf.d/
sudo cp  settings/xorg/* /etc/X11/xorg.conf.d/

result=$(systemd-detect-virt)

if [ $result = "none" ];then

	echo
	tput setaf 2
	echo "################################################################"
	echo "####### Copy paste virtual box template"
	echo "################################################################"
	tput sgr0
	echo	

	[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
	sudo cp -rf settings/virtualbox-template/* ~/VirtualBox\ VMs/
	cd ~/VirtualBox\ VMs/
	tar -xzf template.tar.gz
	rm -f template.tar.gz	

else

	echo
	tput setaf 3
	echo "################################################################"
	echo "### You are on a virtual machine - skipping VirtualBox"
	echo "### Template not copied over"
	echo "################################################################"
	tput sgr0
	echo

fi

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo
