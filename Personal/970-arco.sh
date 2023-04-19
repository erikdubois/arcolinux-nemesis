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

if grep -q "ArcoLinux" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ArcoLinux"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Change gtk-3.0 config"
	echo
	FIND="Sardi-Arc"
	REPLACE="Surfn-Arc"
	sed -i "s/$FIND/$REPLACE/g" $HOME/.config/gtk-3.0/settings.ini
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/gtk-3.0/settings.ini

	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo
		
		echo
		echo "Changing the icons and theme"
		echo

		FIND="Arc-Dark"
		REPLACE="Arc-Dawn-Dark"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		FIND="Sardi-Arc"
		REPLACE="Surfn-Arc"
		sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

	fi

	echo
	echo "ArchLinux Logout - handy icons"
	echo
	[ -d $HOME"/.config/archlinux-logout/" ] || mkdir -p $HOME"/.config/archlinux-logout"
	cp  $installed_dir/settings/archlinux-logout/archlinux-logout-handy.conf $HOME/.config/archlinux-logout/archlinux-logout.conf
	sudo cp  $installed_dir/settings/archlinux-logout/archlinux-logout-handy.conf /etc/archlinux-logout.conf

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

