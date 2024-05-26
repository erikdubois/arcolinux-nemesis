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

echo "################################################################"
echo "################### Personal directories to create"
echo "################################################################"
tput sgr0

[ -d /etc/skel/.config ] || sudo mkdir -p /etc/skel/.config
[ -d /personal ] || sudo mkdir -p /personal

[ -d $HOME"/.bin" ] || mkdir -p $HOME"/.bin"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.local/share/icons" ] || mkdir -p $HOME"/.local/share/icons"
[ -d $HOME"/.local/share/themes" ] || mkdir -p $HOME"/.local/share/themes"
[ -d $HOME"/.config" ] || mkdir -p $HOME"/.config"
[ -d $HOME"/.config/xfce4" ] || mkdir -p $HOME"/.config/xfce4"
[ -d $HOME"/.config/xfce4/xfconf" ] || mkdir -p $HOME"/.config/xfce4/xfconf"
[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
[ -d $HOME"/.config/gtk-4.0" ] || mkdir -p $HOME"/.config/gtk-4.0"
[ -d $HOME"/.config/variety" ] || mkdir -p $HOME"/.config/variety"
[ -d $HOME"/.config/fish" ] || mkdir -p $HOME"/.config/fish"
[ -d $HOME"/.config/obs-studio" ] || mkdir -p $HOME"/.config/obs-studio"
[ -d $HOME"/.config/neofetch" ] || mkdir -p $HOME"/.config/neofetch"
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"

echo
tput setaf 2
echo "################################################################"
echo "################### Personal settings to install - any OS"
echo "################################################################"
tput sgr0
echo

echo
echo "Sublime text settings"
echo
[ -d $HOME"/.config/sublime-text/Packages/User" ] || mkdir -p $HOME"/.config/sublime-text/Packages/User"
cp  $installed_dir/settings/sublimetext/Preferences.sublime-settings $HOME/.config/sublime-text/Packages/User/Preferences.sublime-settings
echo

echo "Blueberry symbolic link"
echo
#uncommenting so that we see the bluetooth icon in our toolbars
gsettings set org.blueberry use-symbolic-icons false

echo
echo "VirtualBox check - copy/paste template or not"
echo

result=$(systemd-detect-virt)
if [ $result = "none" ];then

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
	echo "### We will set your screen resolution with xrandr"
	echo "################################################################"
	tput sgr0
	echo

	xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal

fi

if grep -q "ArcoLinux" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Personal settings to install - ArcoLinux"
	echo "################################################################"
	tput sgr0
	echo

	echo "Installing all shell files"
	echo
	cp $installed_dir/settings/shell-personal/.bashrc-personal ~/.bashrc-personal
	cp $installed_dir/settings/shell-personal/.zshrc ~/.zshrc
	sudo cp -f $installed_dir/settings/shell-personal/.zshrc /etc/skel/.zshrc
	cp $installed_dir/settings/shell-personal/.zshrc-personal ~/.zshrc-personal
	cp $installed_dir/settings/fish/alias.fish ~/.config/fish/alias.fish
	echo

	echo "Installing screenkey for teaching"
	echo
	cp $installed_dir/settings/screenkey/screenkey.json ~/.config/
	echo
	echo "Adding personal looks to /personal"
	echo
	sudo cp -arf $installed_dir/settings/personal-folder/personal-iso/* /personal
	echo
	echo "Adding obs-studio settings"
	echo
	sudo cp -arf $installed_dir/settings/obs-studio/* ~/.config/obs-studio/
	echo
	
	echo "To personal Kvantum setup"
	echo
	[ -d $HOME"/.config/Kvantum" ] || mkdir -p $HOME"/.config/Kvantum"
	cp -r $installed_dir/settings/Kvantum/* $HOME/.config/Kvantum
	[ -d /etc/skel/.config/Kvantum ] || sudo mkdir -p /etc/skel/.config/Kvantum
	sudo cp -r $installed_dir/settings/Kvantum/* /etc/skel/.config/Kvantum

	echo
	echo "To default xfce settings"
	[ -d $HOME"/.config/xfce4/xfconf/xfce-perchannel-xml/" ] || mkdir -p $HOME"/.config/xfce4/xfconf/xfce-perchannel-xml/"
	cp  $installed_dir/settings/xfce/xsettings.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
	[ -d /etc/skel/.config/xfce4 ] || sudo mkdir -p /etc/skel/.config/xfce4
	[ -d /etc/skel/.config/xfce4/xfconf ] || sudo mkdir -p /etc/skel/.config/xfce4/xfconf
	[ -d /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml ] || sudo mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
	sudo cp  $installed_dir/settings/xfce/xsettings.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
	echo

	echo 
	echo "To default gtk-3.0 config"
	[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
	cp  $installed_dir/settings/gtk3/settings.ini $HOME/.config/gtk-3.0
	[ -d "/etc/skel/.config/gtk-3.0" ] || sudo mkdir -p "/etc/skel/.config/gtk-3.0"
	sudo cp  $installed_dir/settings/gtk3/settings.ini /etc/skel/.config/gtk-3.0
	echo

	echo
	echo "Adding personal thunar to .config/thunar"
	[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
	cp  $installed_dir/settings/thunar/uca.xml $HOME/.config/Thunar
	[ -d /etc/skel/.config/Thunar ] || sudo mkdir -p /etc/skel/.config/Thunar
	sudo cp  $installed_dir/settings/thunar/uca.xml /etc/skel/.config/Thunar
	echo

	echo
	echo "Installing personal settings of variety"
	[ -d $HOME"/.config/variety" ] || mkdir -p $HOME"/.config/variety"
	cp $installed_dir/settings/variety/variety.conf ~/.config/variety/
	[ -d /etc/skel/.config/variety ] || sudo mkdir -p /etc/skel/.config/variety
	sudo cp $installed_dir/settings/variety/variety.conf /etc/skel/.config/variety/
	echo

	echo
	echo "Changing icons for telegram"
	sh $installed_dir/settings/telegram/adapt-telegram.sh
	echo

	echo
	echo "Changing icons for flameshot"
	sh $installed_dir/settings/flameshot/adapt-flameshot.sh
	echo

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo
