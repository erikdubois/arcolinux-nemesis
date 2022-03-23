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
[ -d "/personal" ] || sudo mkdir -p "/personal"
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

if [ -f /etc/lightdm/lightdm-gtk-greeter.conf ]; then

	echo
	echo "Changing the look of lightdm gtk greeter"
	echo

	FIND="#theme-name="
	REPLACE="theme-name=Arc-Dark"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/lightdm/lightdm-gtk-greeter.conf

	sudo cp $installed_dir/settings/wallpaper/lightdm.jpg /etc/lightdm/lightdm.jpg

	FIND="#background="
	REPLACE="background=\/etc\/lightdm\/lightdm.jpg"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/lightdm/lightdm-gtk-greeter.conf

fi

if [ -f /usr/share/xsessions/xfce.desktop ]; then
	if grep -q "Arch Linux" /etc/os-release; then
		echo
		echo "Changing the whiskermenu"
		echo		
		cp $installed_dir/settings/archlinux/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
	fi

	if grep -q "carli" /etc/os-release; then
		echo
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/carli/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
	fi

	if grep -q "AA" /etc/dev-rel; then
	echo
	echo "Changing the whiskermenu"
	echo
	cp $installed_dir/settings/aa/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
	fi

	FIND="Arc-Dark"
	REPLACE="Arc-Dawn-Dark"
	sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

	FIND="Sardi-Arc"
	REPLACE="Edu-Papirus-Dark-Tela"
	sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

fi

if grep -q "carli" /etc/os-release; then
	echo
	echo "Changing sddm theme"
	echo
	sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
	FIND="Current=breeze"
	REPLACE="Current=arcolinux-simplicity"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf
fi

if [ -f /usr/share/xsessions/cinnamon.desktop ]; then
	if [ -f /usr/bin/sddm ]; then
		echo
		echo "Changing sddm theme"
		echo
		sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
		FIND="Current=breeze"
		REPLACE="Current=arcolinux-simplicity"
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf
	fi
fi

echo
tput setaf 2
echo "################################################################"
echo "################### Personal settings installed"
echo "################################################################"
tput sgr0
echo
