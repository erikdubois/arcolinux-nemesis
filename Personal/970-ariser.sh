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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

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

if [ -f /usr/local/bin/get-nemesis-on-ariser ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ARISER iso"
	echo "################################################################"
	tput sgr0
	echo

	if [ -f /etc/default/grub ]; then
		sudo cp $installed_dir/settings/ariser/grub /etc/default/grub
		sudo cp $installed_dir/settings/ariser/theme.txt /boot/grub/themes/Vimix/theme.txt

		sudo grub-mkconfig -o /boot/grub/grub.cfg
	fi

	if [ -f /etc/environment ]; then
		echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
	fi

	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	#sudo groupadd autologin
	sudo usermod -a -G autologin $USER

	if [ -f /etc/lightdm/lightdm.conf ]; then

		echo
		echo "Autologin to lightdm"
		echo
		FIND="#autologin-user="
		REPLACE="autologin-user=$USER"
    	sudo sed -i "s/$FIND/$REPLACE/g" /etc/lightdm/lightdm.conf

		FIND="#autologin-session="
		REPLACE="autlogin-session=xfce"
    	sudo sed -i "s/$FIND/$REPLACE/g" /etc/lightdm/lightdm.conf

	fi

	# list=(
	# )

	# count=0

	# for name in "${list[@]}" ; do
	#     count=$[count+1]
	#     tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	#     func_install $name
	# done

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

    	cp -arf /etc/skel/. ~
    
		echo
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/ariser/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
		sudo cp $installed_dir/settings/ariser/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

		echo
		echo "Changing the icons and theme"
		echo

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
    	sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="arcolinux-candy-beauty"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
    	sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

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

	fi

fi
