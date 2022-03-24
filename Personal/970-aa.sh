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

if [ -f /usr/local/bin/get-nemesis-on-aa ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on a AA iso"
	echo "################################################################"
	tput sgr0
	echo

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

		echo
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/aa/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

		FIND="Sardi-Arc"
		REPLACE="Edu-Papirus-Dark-Tela"
		sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

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

	if [ -f /usr/share/xsessions/plasma.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Plasma"
		echo "################################################################"
		tput sgr0
		echo
	fi

	if [ -f /usr/share/xsessions/mate.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Mate"
		echo "################################################################"
		tput sgr0
		echo
	fi

	if [ -f /usr/share/xsessions/cinnamon.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Cinnamon"
		echo "################################################################"
		tput sgr0
		echo
	fi	

fi