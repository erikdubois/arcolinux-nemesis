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

# https://www.youtube.com/watch?v=HMxHUvN6VGo
# https://gitlab.com/stephan-raabe/

sudo pacman -S --noconfirm --needed starship
sudo pacman -S --noconfirm --needed fastfetch
sudo pacman -S --noconfirm --needed rofi-lbonn-wayland
sudo pacman -S --noconfirm --needed hyprland-git
sudo pacman -S --noconfirm --needed waybar-git
sudo pacman -S --noconfirm --needed hyprpaper
sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
sudo pacman -S --noconfirm --needed hypridle
sudo pacman -S --noconfirm --needed chromium

cp /usr/local/share/arcolinux/.bashrc $HOME/dotfiles/.bashrc-arcolinux
cp /etc/skel/.config/alacritty/alacritty.toml $HOME/dotfiles/alacritty/alacritty.toml

if ! grep -q "~/dotfiles/.bashrc-arcolinux" $HOME/.bashrc; then
	echo "
[[ -f ~/dotfiles/.bashrc-arcolinux ]] && . ~/dotfiles/.bashrc-arcolinux" | tee -a $HOME/dotfiles/.bashrc
	source  ~/.bashrc
fi

if ! grep -q "# Keybindings ArcoLinux" $HOME/dotfiles/hypr/conf/keybindings/default.conf; then

echo "

# Keybindings ArcoLinux
bind = SUPER SHIFT, Return, exec, ~/dotfiles/.settings/filemanager.sh
bind = SUPER SHIFT, Q, killactive
bind = SUPER, X, exec, archlinux-logout
bind = SUPER SHIFT, X, exec, arcolinux-powermenu
bind = , F12, exec, xfce4-terminal --drop-down
bind = CTRL ALT, T, exec, kitty
bind = CTRL ALT, Return, exec, kitty
bind = SUPER , D, exec, rofi -show drun -replace -i
bind = SUPER SHIFT, D, exec, rofi -show drun -replace -i" | tee -a $HOME/dotfiles/hypr/conf/keybindings/default.conf
fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo