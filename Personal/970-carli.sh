#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website : https://www.erikdubois.be
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

if [ -f /usr/local/bin/get-nemesis-on-carli ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on a CARLI iso"
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
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/carli/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
		sudo cp $installed_dir/settings/carli/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="Edu-Papirus-Dark-Tela"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		echo
		echo "Changing sddm theme"
		echo
		sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
		FIND="Current=breeze"
		REPLACE="Current=arcolinux-simplicity"
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf

	fi

fi
