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

if grep -q "ArchBang" /etc/os-release; then

	echo
	tput setaf 2
	echo "################################################################"
	echo "################### We are on ArchBang"
	echo "################################################################"
	tput sgr0
	echo

	echo "Removing conflicting files"
	sudo rm -f /etc/skel/.config/variety/variety.conf

	echo "Variety conf ArcoLinux"
	sudo pacman -S --noconfirm --needed arconet-variety-config
	sudo pacman -S --noconfirm --needed arcolinux-variety-autostart-git
	
	echo "Alacritty conf ArcoLinux"
	sudo pacman -S --noconfirm --needed arcolinux-alacritty-git

	echo "Adding picom"
	sudo pacman -S --noconfirm --needed picom

	echo "Installing and setting sddm"
	sudo pacman -S --noconfirm --needed sddm arcolinux-sddm-simplicity-git
	sudo systemctl enable -f sddm

	echo
	echo "Adding nanorc"
	if [ -f /etc/nanorc ]; then
    	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
	fi

	echo
	echo "Setting environment variables"
	echo

	if ! grep -q "XDG_CURRENT_DESKTOP" $HOME/.config/openbox/environment; then
		echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/openbox/environment
		echo "XDG_CURRENT_DESKTOP=openbox" | sudo tee -a $HOME/.config/openbox/environment
		echo "XDG_SESSION_DESKTOP=openbox" | sudo tee -a $HOME/.config/openbox/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a $HOME/.config/openbox/environment
		echo "EDITOR=nano" | sudo tee -a $HOME/.config/openbox/environment
		echo "BROWSER=firefox" | sudo tee -a $HOME/.config/openbox/environment
	fi

	if ! grep -q "XDG_CURRENT_DESKTOP" /etc/environment; then
		echo -e ${NEWLINEVAR} | sudo tee -a /etc/environment
		echo "XDG_CURRENT_DESKTOP=openbox" | sudo tee -a /etc/environment
		echo "XDG_SESSION_DESKTOP=openbox" | sudo tee -a /etc/environment
		echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
		echo "EDITOR=nano" | sudo tee -a /etc/environment
		echo "BROWSER=firefox" | sudo tee -a /etc/environment
	fi

	echo
	echo "Change gtk-3.0 config"
	echo
	FIND="gtk-theme-name=Adwaita-dark"
	REPLACE="gtk-theme-name=Arc-Dark"
	sed -i "s/$FIND/$REPLACE/g" $HOME/.config/gtk-3.0/settings.ini
	#sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/gtk-3.0/settings.ini

	echo
	echo "Change gtk-3.0 config"
	echo
	FIND="gtk-icon-theme-name=Arc"
	REPLACE="gtk-icon-theme-name=a-candy-beauty-icon-theme"
	sed -i "s/$FIND/$REPLACE/g" $HOME/.config/gtk-3.0/settings.ini
	#sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/gtk-3.0/settings.ini

	echo
	echo "Change gtk-3.0 config"
	echo
	FIND="gtk-cursor-theme-name=Adwaita"
	REPLACE="gtk-cursor-theme-name=Bibata-Modern-Ice"
	sed -i "s/$FIND/$REPLACE/g" $HOME/.config/gtk-3.0/settings.ini
	#sudo sed -i "s/$FIND/$REPLACE/g" /etc/skel/.config/gtk-3.0/settings.ini
	
	echo	
	echo "When on Openbox"
	if [ -f /usr/share/xsessions/openbox.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We are on Openbox"
		echo "################################################################"
		tput sgr0
		echo

		echo "Changing theme and icon theme"
		sudo pacman -S --noconfirm --needed openbox-arc-git 
		sudo pacman -S --noconfirm --needed arcolinux-openbox-themes-git

		if ! grep -q "picom" $HOME/.config/openbox/autostart; then
			echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/openbox/autostart;
			echo "picom &" | sudo tee -a $HOME/.config/openbox/autostart;
		fi

	fi


	echo	
	echo "When Chadwm is installed - default to it"
	if [ -f /usr/share/xsessions/chadwm.desktop ]; then
		echo
		tput setaf 2
		echo "################################################################"
		echo "################### We choose to install chadwm"
		echo "################################################################"
		tput sgr0
		echo
		
		if ! grep -q "#exec openbox-session" $HOME/.xinitrc; then
			FIND="exec openbox-session"
			REPLACE="#exec openbox-session"
			sed -i "s/$FIND/$REPLACE/g" $HOME/.xinitrc
		fi


		if ! grep -q "exec-chadwm" $HOME/.xinitrc; then
			echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.xinitrc;
			echo "exec exec-chadwm" | sudo tee -a $HOME/.xinitrc;
		fi

		if ! grep -q '#run "conky' $HOME/.config/arco-chadwm/scripts/run.sh; then
			FIND='run "conky'
			REPLACE='#run "conky'
			sed -i "s/$FIND/$REPLACE/g" $HOME/.config/arco-chadwm/scripts/run.sh
		fi

	fi


  	echo
  	tput setaf 6
  	echo "################################################################"
  	echo "################### Done"
  	echo "################################################################"
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