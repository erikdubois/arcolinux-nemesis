#!/bin/bash
#set -e
##################################################################################################################################
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
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

if grep -q "ArchBang" /etc/os-release; then

	echo
	tput setaf 2
	echo "########################################################################"
	echo "################### We are on ArchBang"
	echo "################### sudo pacman-key --init and --populate are still necessary to start"
	echo "########################################################################"
	tput sgr0
	echo


	echo "Installing and setting sddm"
	sudo pacman -S --noconfirm --needed sddm
	sudo systemctl enable -f sddm
	/usr/local/bin/fix-sddm-conf
	sudo pacman -S edu-sddm-simplicity-git --noconfirm --needed


	echo "Getting my azerty keyboard in - TTY"
	# Define target file
	file="/etc/vconsole.conf"

	# Make a backup
	sudo cp "$file" "${file}.nemesis"

	# Check if KEYMAP line exists
	if grep -q '^KEYMAP=' "$file"; then
	    # If exists, replace the line
	    sudo sed -i 's|^KEYMAP=.*|KEYMAP=be-latin1|' "$file"
	else
	    # If not exists, append it
	    sudo echo 'KEYMAP=be-latin1' >> "$file"
	fi

if [ -f /etc/X11/xorg.conf.d/01-keyboard-layout.conf ]; then
  sudo tee /etc/X11/xorg.conf.d/01-keyboard-layout.conf > /dev/null << 'EOF'
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "be"
        Option "XkbVariant" ""
EndSection
EOF
fi



	# Remove duplicate KEYMAP lines, keeping the first one
	#awk '!seen[$0]++' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"


	echo
	echo "Setting environment variables"
	echo

	if ! grep -q "XDG_CURRENT_DESKTOP" $HOME/.config/openbox/environment; then
		echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/openbox/environment
		echo "XDG_CURRENT_DESKTOP=openbox" | sudo tee -a $HOME/.config/openbox/environment
		echo "XDG_SESSION_DESKTOP=openbox" | sudo tee -a $HOME/.config/openbox/environment
	fi

	if ! grep -q "XDG_CURRENT_DESKTOP" /etc/environment; then
		echo -e ${NEWLINEVAR} | sudo tee -a /etc/environment
		echo "XDG_CURRENT_DESKTOP=openbox" | sudo tee -a /etc/environment
		echo "XDG_SESSION_DESKTOP=openbox" | sudo tee -a /etc/environment
	fi
	
	echo	
	echo "When on Openbox"
	if [ -f /usr/share/xsessions/openbox.desktop ]; then
		echo
		tput setaf 2
		echo "########################################################################"
		echo "################### We are on Openbox"
		echo "########################################################################"
		tput sgr0
		echo

		echo "Autostarting picom"
		if ! grep -q "picom" $HOME/.config/openbox/autostart; then
			echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/openbox/autostart;
			echo "picom &" | sudo tee -a $HOME/.config/openbox/autostart;
		fi

	fi

  	echo
  	tput setaf 6
  	echo "########################################################################"
  	echo "################### Done"
  	echo "########################################################################"
  	tput sgr0
  	echo

fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo