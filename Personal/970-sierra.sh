#!/bin/bash
set -e
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

if [ -f /usr/local/bin/get-nemesis-on-sierra ]; then

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
	tput setaf 2
	echo "################################################################"
	echo "################### We are on Sierra"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "copying cursor file"
	if [ -d /usr/share/icons/default/cursors ]; then
		sudo rm /usr/share/icons/default/cursors
	fi
	sudo cp -f $installed_dir/settings/cursor/* /usr/share/icons/default
	echo

	echo
	echo "Copying sddm files"
	sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm/sddm.conf /etc/sddm.conf

	sudo mkdir /etc/sddm.conf.d
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf
	echo

	echo
	echo "Bootloader time to 1 second"
	if [ -f /boot/loader/loader.conf ]; then
		FIND="timeout 5"
		REPLACE="timeout 1"
		sudo sed -i "s/$FIND/$REPLACE/g" /boot/loader/loader.conf

	fi
	echo

	echo
	echo "sddm autologin"
	FIND="#Session="
	REPLACE="Session=chadwm"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf.d/kde_settings.conf
	FIND="#User="
	REPLACE="User=erik"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf.d/kde_settings.conf
	echo
	
	echo
	echo "Enable fstrim timer"
	sudo systemctl enable fstrim.timer
	echo

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
		echo "Changing the icons and theme"
		echo

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="Edu-Papirus-Dark-Tela"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

	fi

fi
