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
sudo xbps-install --yes fish-shell

# making sure simplescreenrecorder, virtualbox and other apps are dark
sudo cp environment /etc/environment
# .config I would like to have
cp -rv dotfiles/* ~/.config
# theme, cursor, icons, ...
cp -v .gtkrc-2.0 ~

# double - also in install-chadwm for convenience
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp -v uca.xml ~/.config/Thunar/

# changing the appearance of GDM - no bottom logo (ubuntu text)
sudo cp -v empty.png /usr/share/pixmaps/ubuntu-logo-text-dark.png
sudo cp -v empty.png /usr/share/pixmaps/ubuntu-logo-text.png
sudo cp -v empty.png /usr/share/plymouth/ubuntu-logo.png
sudo cp -v empty.png /usr/share/plymouth/themes/spinner/watermark.png

# setting the cursor to bibata everywhere
cp -rv default ~/.icons
sudo rm -r /usr/share/icons/default
sudo cp -rv default /usr/share/icons/

# personal folders I like to have
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Projects" ] || mkdir -p $HOME"/Projects"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"

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

alias update="sudo xbps-install -Su --yes"
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

# Check if virt-what is installed
if ! command -v virt-what &>/dev/null; then
  echo "Error: virt-what is not installed. Install it to proceed."
  exit 1
fi

# Check the virtualization environment
result=$(sudo virt-what)

# Check if running on real metal (not kvm)
if [[ $result != "kvm" ]]; then
  # Define the VirtualBox directory path
  vbox_dir="$HOME/VirtualBox VMs"
  
  # Create the VirtualBox VMs directory if it doesn't exist
  [[ -d "$vbox_dir" ]] || mkdir -p "$vbox_dir"
  
  # Ensure template file exists before attempting to copy
  if [[ -f "template.tar.gz" ]]; then
    # Copy the template to the VirtualBox directory
    sudo cp -rf template.tar.gz "$vbox_dir/"
    
    # Extract and clean up template in the VirtualBox directory
    cd "$vbox_dir"
    tar -xzf template.tar.gz && rm -f template.tar.gz
    
    echo -e "\nRemoving all VirtualBox messages"
    
    # Suppress VirtualBox messages
    if command -v VBoxManage &>/dev/null; then
      VBoxManage setextradata global GUI/SuppressMessages "all"
    else
      echo "Warning: VBoxManage command not found. Please ensure VirtualBox is installed."
    fi
  else
    echo "Error: template.tar.gz not found. Please provide the template file."
  fi

else
  # Output warning for virtual machine environments
  echo
  tput setaf 3
  echo "########################################################################"
  echo "### Running on a virtual machine - skipping VirtualBox setup"
  echo "### Template not copied over"
  echo "### Setting screen resolution with xrandr"
  echo "########################################################################"
  tput sgr0
  echo

  # Set screen resolution
  xrandr --output Virtual1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
fi


# getting archlinux-logout
sudo xbps-install python3-distro --yes
cd $installed_dir
folder="/tmp/archlinux-logout"
if [ -d "$folder" ]; then
    sudo rm -r "$folder"
fi
git clone https://github.com/arcolinux/archlinux-logout /tmp/archlinux-logout

# changing for runinit
FIND="systemctl reboot"
REPLACE="sudo reboot"
sed -i "s/$FIND/$REPLACE/g" /tmp/archlinux-logout/usr/share/archlinux-logout/archlinux-logout.py

FIND="systemctl poweroff"
REPLACE="sudo shutdown -r now"
sed -i "s/$FIND/$REPLACE/g" /tmp/archlinux-logout/usr/share/archlinux-logout/archlinux-logout.py


sudo cp -r /tmp/archlinux-logout/etc/* /etc
sudo cp -r /tmp/archlinux-logout/usr/* /usr
sudo rm -r /usr/share/archlinux-betterlockscreen
sudo rm /usr/share/applications/archlinux-betterlockscreen.desktop

# personalisation of archlinux-logout
[ -d $HOME"/.config/archlinux-logout" ] || mkdir -p $HOME"/.config/archlinux-logout"
cp -v archlinux-logout.conf ~/.config/archlinux-logout/

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

# Arc Dawn
git clone https://github.com/arcolinux/arcolinux-arc-dawn  /tmp/arcolinux-arc-dawn
cd /tmp/arcolinux-arc-dawn/usr/share/themes

cp -r * ~/.themes

echo
FIND="GTK_THEME=Arc-Dark"
REPLACE="GTK_THEME=Arc-Dawn-Dark"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/environment

# installing sparklines/spark
sudo sh -c "curl https://raw.githubusercontent.com/holman/spark/master/spark -o /usr/local/bin/spark && chmod +x /usr/local/bin/spark"

#!/bin/bash

# Check if wget and unzip are installed
if ! command -v wget &>/dev/null || ! command -v unzip &>/dev/null; then
  echo "Error: wget and unzip are required. Install them to proceed."
  exit 1
fi

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


tput setaf 6
echo "########################################################################"
echo "###### Personal choices done - reboot for fish"
echo "########################################################################"
tput sgr0
echo
