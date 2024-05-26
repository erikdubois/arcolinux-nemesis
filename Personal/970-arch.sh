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

if [ ! -f /etc/dev-rel ] ; then 

	if grep -q "archlinux" /etc/os-release; then

		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on ARCH LINUX"
		echo "################################################################"
		tput sgr0
		echo

		echo
		echo "Installing edu packages"
		sudo pacman -S --noconfirm --needed edu-skel-git
	  	sudo pacman -S --noconfirm --needed edu-xfce-git
	  	sudo pacman -S --noconfirm --needed edu-system-git

		echo
		echo "Pacman parallel downloads	"
		FIND="#ParallelDownloads = 5"
		REPLACE="ParallelDownloads = 5"
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/pacman.conf

		echo
		echo "Bootloader time to 1 second"
		if [ -f /boot/loader/loader.conf ]; then
			FIND="timeout 5"
			REPLACE="timeout 1"
			sudo sed -i "s/$FIND/$REPLACE/g" /boot/loader/loader.conf

		fi
		echo

		echo
		echo "Adding nanorc"
		if [ -f /etc/nanorc ]; then
	    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
		fi

		echo
		echo "################################################################"
		echo "Getting latest /etc/nsswitch.conf from ArcoLinux"
		echo "################################################################"
		echo
		sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
		sudo wget https://raw.githubusercontent.com/arcolinux/arcolinuxl-iso/master/archiso/airootfs/etc/nsswitch.conf -O $workdir/etc/nsswitch.conf

		echo	
		echo "When on Xfce4"
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
			cp $installed_dir/settings/archlinux/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
			sudo cp $installed_dir/settings/archlinux/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

			FIND="Arc-Dark"
			REPLACE="Arc-Dawn-Dark"
			sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
			sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

			FIND="Sardi-Arc"
			REPLACE="a-candy-beauty-icon-theme"
			sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
			sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

		fi

		echo
		tput setaf 6
		echo "################################################################"
		echo "################### Done"
		echo "################################################################"
		tput sgr0
		echo

	fi

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo