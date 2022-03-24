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


if grep -q "alci" /usr/local/bin/get-nemesis; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on an ALCI iso"
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

















	if grep -q "AA" /etc/dev-rel; then
	echo
	echo "Changing the whiskermenu"
	echo
	cp $installed_dir/settings/aa/whiskermenu-7.rc ~/.config/xfce4/panel/whiskermenu-7.rc
	fi

	FIND="Arc-Dark"
	REPLACE="Arc-Dawn-Dark"
	sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

	FIND="Sardi-Arc"
	REPLACE="Edu-Papirus-Dark-Tela"
	sudo sed -i "s/$FIND/$REPLACE/g" ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml	

fi

if grep -q "carli" /etc/os-release; then
	echo
	echo "Changing sddm theme"
	echo
	sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
	FIND="Current=breeze"
	REPLACE="Current=arcolinux-simplicity"
	sudo sed -i "s/$FIND/$REPLACE/g" /etc/sddm.conf
fi



if [ ! -f /usr/bin/hwinfo ]; then
  sudo pacman -S --noconfirm --needed hwinfo
fi

if hwinfo | grep "CORSAIR K70" > /dev/null 2>&1 ; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Corsair keyboard to be installed"
	echo "################################################################"
	tput sgr0
	echo

	sudo pacman -S --noconfirm --needed ckb-next-git
	installed_dir=$(pwd)
	[ -d $HOME"/.config/ckb-next" ] || mkdir -p $HOME"/.config/ckb-next"

	cp -r $installed_dir/settings/ckb-next/ckb-next.conf ~/.config/ckb-next.conf
	cp -f $installed_dir/settings/ckb-next/ckb-next.autostart.desktop ~/.config/autostart/ckb-next.autostart.desktop
	
	sudo systemctl enable ckb-next-daemon
	sudo systemctl start ckb-next-daemon

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### Corsair keyboard installed"
	echo "################################################################"
	tput sgr0
	echo

fi
