#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
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

echo
tput setaf 2
echo "########################################################################"
echo "################### Personal choices"
echo "########################################################################"
tput sgr0
echo

# installing extra shell
sudo apt install -y fish

# Going for fish as the default shell
echo
echo "To fish we go"
echo
FIND="\/bin\/bash"
REPLACE="\/usr\/bin\/fish"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/passwd
echo

# making sure simplescreenrecorder, virtualbox and other apps are dark
sudo cp -v environment /etc/environment
# .config I would like to have
cp -rv dotfiles/* ~/.config
# theme, cursor, icons, ...
cp -v .gtkrc-2.0 ~

# setting the cursor to bibata everywhere
cp -rv default ~/.icons
sudo rm -r /usr/share/icons/default
sudo cp -rv default /usr/share/icons/

# personal folders I like to have
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Dropbox" ] || mkdir -p $HOME"/Dropbox"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"

# kill my system and go to GDM - CTRL ALT BACKSPACE
sudo cp 99-killX.conf  /etc/X11/xorg.conf.d/

# minimal setup for bashrc
if [ -f ~/.bashrc ]; then
	echo '
### EXPORT ###
export EDITOR='nano'
export VISUAL='nano'
export HISTCONTROL=ignoreboth:erasedups
export PAGER='most'

alias update="sudo apt update && sudo apt upgrade"
alias probe="sudo -E hw-probe -all -upload"
alias nenvironment="sudo $EDITOR /etc/environment"
alias sr="reboot"' | tee -a ~/.bashrc
fi

# when on real metal install a template
result=$(systemd-detect-virt)
if [ $result = "none" ];then

	echo
	echo "Removing all the messages virtualbox produces"
	echo
	VBoxManage setextradata global GUI/SuppressMessages "all"

	[ -d $HOME"/VirtualBox VMs" ] || mkdir -p $HOME"/VirtualBox VMs"
	sudo cp -rf template.tar.gz ~/VirtualBox\ VMs/
	cd ~/VirtualBox\ VMs/
	tar -xzf template.tar.gz
	rm -f template.tar.gz	

else

	echo
	tput setaf 3
	echo "########################################################################"
	echo "### You are on a virtual machine - skipping VirtualBox"
	echo "### Template not copied over"
	echo "### We will set your screen resolution with xrandr"
	echo "########################################################################"
	tput sgr0
	echo

	# Extract the correct Virtual output (either Virtual-1 or Virtual1)
	VIRTUAL_OUTPUT=$(xrandr | grep -oP '^Virtual-?1(?=\sconnected)')

	# If an output was found, apply xrandr settings
	if [[ -n $VIRTUAL_OUTPUT ]]; then
	    xrandr --output "$VIRTUAL_OUTPUT" --primary --mode 1920x1080 --pos 0x0 --rotate normal
	else
	    echo "No Virtual display found."
	fi

fi

# getting archlinux-logout
cd $installed_dir
sudo rm -rf /tmp/archlinux-logout
git clone https://github.com/arcolinux/archlinux-logout /tmp/archlinux-logout
sudo cp -r /tmp/archlinux-logout/etc/* /etc
sudo cp -r /tmp/archlinux-logout/usr/* /usr
sudo rm -r /usr/share/archlinux-betterlockscreen
sudo rm /usr/share/applications/archlinux-betterlockscreen.desktop

# personalisation of archlinux-logout
[ -d $HOME"/.config/archlinux-logout" ] || mkdir -p $HOME"/.config/archlinux-logout"
cp -v archlinux-logout.conf ~/.config/archlinux-logout/
echo

# prevention ads - tracking - hblock
# https://github.com/hectorm/hblock
sudo rm -rf /tmp/hblock
git clone https://github.com/hectorm/hblock  /tmp/hblock
cd /tmp/hblock
sudo make install
hblock
echo

# Arc Dawn
sudo rm -rf /tmp/arcolinux-arc-dawn
git clone https://github.com/arcolinux/arcolinux-arc-dawn  /tmp/arcolinux-arc-dawn
cd /tmp/arcolinux-arc-dawn/usr/share/themes
cp -r * ~/.themes
echo


# getting edu-variety
sudo rm -rf /tmp/edu-variety-config
git clone https://github.com/erikdubois/edu-variety-config /tmp/edu-variety-config
cp -r /tmp/edu-variety-config/etc/skel/.config/* ~/.config/

# installing sparklines/spark
sudo sh -c "curl https://raw.githubusercontent.com/holman/spark/master/spark -o /usr/local/bin/spark && chmod +x /usr/local/bin/spark"

tput setaf 6
echo "########################################################################"
echo "###### Personal choices done - reboot for fish"
echo "########################################################################"
tput sgr0
echo
