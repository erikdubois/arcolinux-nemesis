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

echo
tput setaf 2
echo "################################################################"
echo "################### Display manager"
echo "################################################################"
tput sgr0
echo

# we are on Arch Linux

if grep -q "archlinux" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ARCH LINUX"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Installing and changing sddm theme"
	echo
	echo "Copying sddm files"
	sudo pacman -S --noconfirm --needed sddm arcolinux-sddm-simplicity-git
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm/sddm.conf /etc/sddm.conf

	[ -d /etc/sddm.conf.d ] || sudo mkdir /etc/sddm.conf.d
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf

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

    	sudo groupadd autologin
		sudo usermod -a -G autologin $USER

	fi

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

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

# we are on ALCI

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ALCI"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Changing sddm theme"
	if [ -f /usr/lib/sddm/sddm.conf.d/default.conf ]; then
		sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
		echo
		echo "Changing sddm theme"
		echo
		sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
		FIND="Current="
		REPLACE="Current=arcolinux-simplicity"
		sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf
	fi

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

# we are on ArcoLinux

if grep -q "ArcoLinux" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on an ArcoLinux iso"
	echo "################################################################"
	tput sgr0
	echo

	echo "Nothing to do"

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

# we are on Ariser

if [ -f /usr/local/bin/get-nemesis-on-ariser ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ARISER"
	echo "################################################################"
	tput sgr0
	echo

	
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

		sudo usermod -a -G autologin $USER

	fi

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

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi

# we are on Carli

if [ -f /usr/local/bin/get-nemesis-on-carli ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on CARLI"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Changing sddm theme"
	echo
	sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
	FIND="Current=breeze"
	REPLACE="Current=arcolinux-simplicity"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi


# when on Eos

if grep -q "EndeavourOS" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "############### We are on EOS"
	echo "################################################################"
	echo
	tput sgr0

	sudo groupadd autologin
	sudo usermod -a -G autologin $USER

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

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo
fi



# when on Garuda

if grep -q "Garuda" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "############### We are on an GARUDA iso"
	echo "################################################################"
	echo
	tput sgr0

	echo "Nothing to do"

	echo
	tput setaf 6
	echo "################################################################"
	echo "################### Done"
	echo "################################################################"
	tput sgr0
	echo

fi


# when on sierra

if [ -f /usr/local/bin/get-nemesis-on-sierra ]; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on Sierra"
	echo "################################################################"
	tput sgr0
	echo

	echo
	echo "Copying sddm files"
	sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm/sddm.conf /etc/sddm.conf

	[ -d /etc/sddm.conf.d ] || sudo mkdir /etc/sddm.conf.d
	sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf
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
	tput setaf 6
	echo "######################################################"
	echo "###################  $(basename $0) done"
	echo "######################################################"
	tput sgr0
	echo

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo