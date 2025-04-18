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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Personal choices"
echo "########################################################################"
tput sgr0
echo

# installing extra shell
sudo dnf install -y fish

# making sure simplescreenrecorder, virtualbox and other apps are dark
sudo cp environment /etc/environment
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
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"

# setting my personal configuration for variety
echo "getting latest variety config from github"
sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf

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

# Going for fish as the default shell
echo
echo "To fish we go"
echo
FIND="\/bin\/bash"
REPLACE="\/usr\/bin\/fish"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/passwd
echo

echo
echo "Removing all the messages virtualbox produces"
echo

VBoxManage setextradata global GUI/SuppressMessages "all"

# when on real metal install a template
result=$(systemd-detect-virt)
if [ $result = "none" ];then

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

	xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal

fi

# getting archlinux-logout
cd $installed_dir
git clone https://github.com/arcolinux/archlinux-logout /tmp/archlinux-logout
sudo cp -r /tmp/archlinux-logout/etc/* /etc
sudo cp -r /tmp/archlinux-logout/usr/* /usr
sudo rm -r /usr/share/archlinux-betterlockscreen
sudo rm /usr/share/applications/archlinux-betterlockscreen.desktop

# personalisation of archlinux-logout
[ -d $HOME"/.config/archlinux-logout" ] || mkdir -p $HOME"/.config/archlinux-logout"
cp -v archlinux-logout.conf ~/.config/archlinux-logout/

# Define temporary and fonts directories
temp_dir="/tmp/hack"
fonts_dir="$HOME/.fonts"

# Download the Hack font zip file to the temporary directory
echo "Downloading Hack font..."
wget -q https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O /tmp/hackfont.zip

# Unzip the downloaded file
echo "Extracting Hack font..."
mkdir -p "$temp_dir"
unzip -o /tmp/hackfont.zip -d "$temp_dir" >/dev/null

# Create fonts directory if it doesn't exist
mkdir -p "$fonts_dir"

# Copy and overwrite existing font files
echo "Installing Hack font to $fonts_dir..."
cp -f "$temp_dir/ttf/"* "$fonts_dir"

# Update font cache
echo "Updating font cache..."
fc-cache -fv

# Clean up temporary files
rm -rf /tmp/hackfont.zip "$temp_dir"

echo "Hack font installation complete."

# prevention ads - tracking - hblock
# https://github.com/hectorm/hblock
git clone https://github.com/hectorm/hblock  /tmp/hblock
cd /tmp/hblock
sudo make install
hblock

tput setaf 6
echo "########################################################################"
echo "###### Personal choices done"
echo "########################################################################"
tput sgr0
echo
