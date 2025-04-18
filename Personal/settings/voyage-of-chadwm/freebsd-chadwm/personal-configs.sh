#!/bin/bash
# set -e
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

installed_dir=$(pwd)

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Personal choices"
echo "########################################################################"
tput sgr0
echo

# installing extra shell
sudo pkg install -y fish

# Going for fish as the default shell
sudo chsh -s /usr/local/bin/fish erik
echo

# making sure simplescreenrecorder, virtualbox and other apps are dark
sudo cp environment /etc/environment
# .config I would like to have
cp -rv dotfiles/* ~/.config
# theme, cursor, icons, ...
cp -v .gtkrc-2.0 ~

# double - also in install-chadwm for convenience
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp -v uca.xml ~/.config/Thunar/

# personal folders I like to have
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"

# setting my personal configuration for variety
cp -v variety.conf ~/.config/variety/

# minimal setup for bashrc
if [ -f ~/.bashrc ]; then
	echo '
### EXPORT ###
export EDITOR='nano'
export VISUAL='nano'
export HISTCONTROL=ignoreboth:erasedups
export PAGER='most'

alias update="sudo pkg update && sudo pkg upgrade"
aalias nenvironment="sudo $EDITOR /etc/environment"
alias sr="sudo reboot"' | tee -a ~/.bashrc
fi

echo
echo "Removing all the messages virtualbox produces"
echo

VBoxManage setextradata global GUI/SuppressMessages "all"

# when on real metal install a template
# Check system hardware information
hw_machine=$(sysctl -n hw.machine)
hw_model=$(sysctl -n hw.model)

# Function to check for virtualization keywords
is_virtual_machine() {
    case "$hw_model" in
        *"VirtualBox"*) return 0 ;;
        *"QEMU"*) return 0 ;;
        *"KVM"*) return 0 ;;
        *"VMware"*) return 0 ;;
        *"Hyper-V"*) return 0 ;;
        *) return 1 ;;
    esac
}

# Perform actions based on whether it's a VM
if is_virtual_machine; then
	echo
	tput setaf 3
	echo "#################################################################################"
	echo "### You are on a virtual machine - skipping"
	echo "#################################################################################"
	tput sgr0
	echo

else
    echo
	tput setaf 3
	echo "#################################################################################"
	echo "### NOT running in a virtual machine - installing template VirtualBox"
	echo "#################################################################################"
	tput sgr0
	echo
    	[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
	sudo cp -rf template.tar.gz ~/VirtualBox\ VMs/
	cd ~/VirtualBox\ VMs/
	tar -xzf template.tar.gz
	rm -f template.tar.gz	
fi

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting Arch Linux Logout"
echo "########################################################################"
tput sgr0
echo

# getting archlinux-logout
cd $installed_dir
folder="/tmp/archlinux-logout"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/archlinux-logout /tmp/archlinux-logout
sudo cp -r /tmp/archlinux-logout/etc/* /etc
sudo cp -r /tmp/archlinux-logout/usr/* /usr
sudo rm -r /usr/share/archlinux-betterlockscreen
sudo rm /usr/share/applications/archlinux-betterlockscreen.desktop

# personalisation of archlinux-logout
[ -d $HOME"/.config/archlinux-logout" ] || mkdir -p $HOME"/.config/archlinux-logout"
cp -v $installed_dir/archlinux-logout.conf ~/.config/archlinux-logout/

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting arc dawn"
echo "########################################################################"
tput sgr0
echo

# Arc Dawn
folder="/tmp/arcolinux-arc-dawn"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/arcolinux-arc-dawn  /tmp/arcolinux-arc-dawn
cd /tmp/arcolinux-arc-dawn/usr/share/themes

cp -r * ~/.themes

FIND="GTK_THEME=Arc-Dark"
REPLACE="GTK_THEME=Arc-Dawn-Dark"
sudo sed -i '' "s|${FIND}|${REPLACE}|g" /etc/environment

# installing sparklines/spark
sudo sh -c "curl https://raw.githubusercontent.com/holman/spark/master/spark -o /usr/local/bin/spark && chmod +x /usr/local/bin/spark"

echo
tput setaf 2
echo "########################################################################"
echo "###### Getting hblock"
echo "########################################################################"
tput sgr0
echo

sudo pkg install -y gmake

# prevention ads - tracking - hblock
# https://github.com/hectorm/hblock
folder="/tmp/hblock"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/hectorm/hblock  /tmp/hblock
cd /tmp/hblock
sudo make install
hblock

tput setaf 6
echo "########################################################################"
echo "###### Personal choices done - reboot for fish"
echo "########################################################################"
tput sgr0
echo
