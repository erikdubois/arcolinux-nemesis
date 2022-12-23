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

#https://wiki.archlinux.org/title/PipeWire
#starting on an ArcoLinuxL iso
#https://wiki.archlinux.org/title/PipeWire#Bluetooth_devices

#compare

sudo pacman -R --noconfirm gnome-bluetooth blueberry
#sudo pacman -R --noconfirm pipewire-pulse
#sudo pacman -R --noconfirm pipewire-alsa
#sudo pacman -Rdd --noconfirm pipewire-jack
#sudo pacman -R --noconfirm pipewire-media-session
#sudo pacman -R --noconfirm pipewire-zeroconf
#sudo pacman -Rdd --noconfirm pipewire
sudo pacman -R --noconfirm pipewire-media-session 
sudo pacman -S --noconfirm --needed pipewire
sudo pacman -S --noconfirm --needed lib32-pipewire
sudo pacman -S --noconfirm --needed wireplumber
sudo pacman -S --noconfirm --needed pipewire-alsa
sudo pacman -Rdd --noconfirm jack2
sudo pacman -S --noconfirm --needed pipewire-jack
sudo pacman -S --noconfirm --needed lib32-pipewire-jack
sudo pacman -S --noconfirm --needed pipewire-zeroconf

sudo pacman -Rdd --noconfirm pulseaudio-alsa
sudo pacman -Rdd --noconfirm pulseaudio-bluetooth
sudo pacman -Rdd --noconfirm pulseaudio
sudo pacman -S --noconfirm --needed pipewire-pulse

sudo pacman -S --noconfirm --needed gnome-bluetooth blueberry
sudo systemctl enable bluetooth.service

echo "Reboot now"
