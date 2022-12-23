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

# when on EOS

###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################

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

###############################################################################

if grep -q "EndeavourOS" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "############### We are on an EOS iso"
	echo "################################################################"
	echo
	tput sgr0

	result=$(systemd-detect-virt)
  	test=$(systemctl is-enabled qemu-guest-agent.service)
  	if [ $test == "enabled" ] &  [ $result == "none" ]; then
  		sudo systemctl disable qemu-guest-agent.service
	fi

	sudo pacman -S --noconfirm --needed edu-skel-git
  	sudo pacman -S --noconfirm --needed edu-system-git

	sudo groupadd autologin
	sudo usermod -a -G autologin $USER

	if [ -f /etc/environment ]; then
		echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee /etc/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo
	echo "################################################################"
	echo "Getting latest /etc/nsswitch.conf from ArcoLinux"
	echo "################################################################"
	echo
	sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
	sudo wget https://raw.githubusercontent.com/arcolinux/arcolinuxl-iso/master/archiso/airootfs/etc/nsswitch.conf -O $workdir/etc/nsswitch.conf

  	if [ -f /usr/share/xsessions/xfce.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Xfce4"
		echo "################################################################"
		tput sgr0
		echo

		sudo pacman -S --noconfirm --needed edu-xfce-git

    	cp -arf /etc/skel/. ~

		echo
		echo "Changing the whiskermenu"
		echo
		cp $installed_dir/settings/eos/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
		sudo cp $installed_dir/settings/eos/whiskermenu-7.rc /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

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

    tput setaf 2
    echo "################################################################"
    echo "Done"
    echo "################################################################"
    echo
    tput sgr0

  fi
fi
