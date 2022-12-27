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

# we are on Ariser

if [ -f /usr/local/bin/get-nemesis-on-ariser ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on Ariser"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Azerty config"
	cp -v $HOME/.config/arco-chadwm/chadwm/config.def-azerty.h $HOME/.config/arco-chadwm/chadwm/config.def.h
	echo

	if [ -f $HOME/.config/arco-chadwm/chadwm/config.h ]; then
		rm $HOME/.config/arco-chadwm/chadwm/config.h
	fi

	cd $HOME/.config/arco-chadwm/chadwm/
	make
	sudo make install

	echo
	echo "Change gtk-3.0 config"
	echo
	FIND="Sardi-Arc"
	REPLACE="arcolinux-candy-beauty"
	sed -i "s/$FIND/$REPLACE/g" $HOME/.config/gtk-3.0/settings.ini
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/gtk-3.0/settings.ini

	if [ -f /etc/environment ]; then
		echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo
	echo "copying cursor file"
	if [ -d /usr/share/icons/default/cursors ]; then
		sudo rm /usr/share/icons/default/cursors
	fi
	sudo cp -f $installed_dir/settings/cursor/* /usr/share/icons/default
	echo

	echo
	echo "Bootloader time to 1 second"
	if [ -f /boot/loader/loader.conf ]; then
		FIND="timeout 5"
		REPLACE="timeout 1"
		sudo sed -i "s/$FIND/$REPLACE/g" /boot/loader/loader.conf

	fi
	echo

	echo "Check if neofetch lolcat is in there"
	echo "Line may change in the future"
	
	if ! grep -q "neofetch | lolcat" $HOME/.bashrc; then
		echo "lolcat added"
		sed -i '362s/neofetch/neofetch | lolcat/g' $HOME/.bashrc
		sudo sed -i '362s/neofetch/neofetch | lolcat/g' /etc/skel/.bashrc
		echo
	fi

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

		cp -arf /etc/skel/. ~

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

	fi

	# systemd

	echo "Journald.conf - volatile"

	FIND="#Storage=auto"
	REPLACE="Storage=auto"
	#REPLACE="Storage=volatile"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/systemd/journald.conf

	echo
	echo "ArchLinux Logout - candy icons"
	echo
	[ -d $HOME"/.config/archlinux-logout/" ] || mkdir -p $HOME"/.config/archlinux-logout"
	cp  $installed_dir/settings/archlinux-logout/archlinux-logout-candy.conf $HOME/.config/archlinux-logout/archlinux-logout.conf
	sudo cp  $installed_dir/settings/archlinux-logout/archlinux-logout-candy.conf /etc/archlinux-logout.conf
	
	echo

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi
