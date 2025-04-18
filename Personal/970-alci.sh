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

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then

	echo
	tput setaf 2
	echo "########################################################################"
	echo "################### We are on ALCI"
	echo "########################################################################"
	tput sgr0
	echo

	echo
	echo "To /usr/bin/fish we go"
	echo

	sudo pacman -S --noconfirm --needed fish
	sudo pacman -S --noconfirm --needed arcolinux-fish-git
	
	# Going for fish as the default shell
	FIND="\/bin\/bash"
	REPLACE="\/usr\/bin\/fish"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/passwd
	echo

	if [ -f /etc/skel/.config/variety/variety.conf ]; then
		sudo rm -f /etc/skel/.config/variety/variety.conf
	fi
	sudo pacman -S --noconfirm --needed arconet-variety-config
	sudo pacman -S --noconfirm --needed arcolinux-alacritty-git
	sudo pacman -S --noconfirm --needed arcolinux-root-git
	sudo pacman -S --noconfirm --needed arcolinux-fish-git
	sudo pacman -S --noconfirm --needed arcolinux-btop-git
	sudo pacman -S --noconfirm --needed kvantum-qt5
	sudo pacman -S --noconfirm --needed arcolinux-kvantum-git
	sudo pacman -S --noconfirm --needed pavucontrol

	# setting my personal configuration for variety
	echo "getting latest variety config from github"
	sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf
	sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O /etc/skel/.config/variety/variety.conf

  	echo
  	echo "Installing grub theme"
	if [ -f /etc/default/grub ]; then

		sudo pacman -S --noconfirm --needed arcolinux-grub-theme-vimix-git
		sudo cp $installed_dir/settings/alci/grub /etc/default/grub
		sudo cp $installed_dir/settings/alci/theme.txt /boot/grub/themes/Vimix/theme.txt

		sudo grub-mkconfig -o /boot/grub/grub.cfg
	fi

	echo
	echo "Adding environment variables"
	sudo cp $installed_dir/settings/environment/environment /etc/environment

	echo
	echo "Adding nanorc"
	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	echo	
	echo "When on Xfce4"
	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "########################################################################"
		echo "################### We are on Xfce4"
		echo "########################################################################"
		tput sgr0
		echo

		cp -arf /etc/skel/. ~

		echo
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/alci/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
		if [ ! -d /etc/skel/.config/xfce4/panel/ ]; then
			sudo mkdir /etc/skel/.config/xfce4/panel/
		fi
		sudo cp $installed_dir/settings/alci/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

		echo
		echo "Changing the icons and theme"
		echo

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="neo-candy-icons"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

	fi

	if grep -q alci-iso-lts /usr/local/bin/get-nemesis-on-alci ; then
		sudo pacman -S --noconfirm --needed xdg-user-dirs-gtk
	fi

	if grep -q alci-iso-zen /usr/local/bin/get-nemesis-on-alci ; then
		sudo pacman -S --noconfirm --needed xdg-user-dirs-gtk
	fi	

	echo
	tput setaf 6
	echo "########################################################################"
	echo "################### Done"
	echo "########################################################################"
	tput sgr0
	echo

fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo