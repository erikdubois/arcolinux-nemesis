#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

#https://wiki.archlinux.org/title/PipeWire
#starting on an ArcoLinuxL iso
#https://wiki.archlinux.org/title/PipeWire#Bluetooth_devices

#compare

sudo pacman -R --noconfirm gnome-bluetooth blueberry
sudo pacman -R --noconfirm pipewire-pulse
sudo pacman -R --noconfirm pipewire-alsa
sudo pacman -Rdd --noconfirm pipewire-jack
sudo pacman -R --noconfirm pipewire-media-session
sudo pacman -R --noconfirm pipewire-zeroconf
sudo pacman -Rdd --noconfirm pipewire

#sudo pacman -S --noconfirm --needed pipewire
#sudo pacman -S --noconfirm --needed pipewire-media-session
#sudo pacman -S --noconfirm --needed pipewire-alsa
#sudo pacman -Rdd --noconfirm jack2
#do pacman -S --noconfirm --needed pipewire-jack
#udo pacman -S --noconfirm --needed pipewire-zeroconf

sudo pacman -S --noconfirm --needed pulseaudio-alsa
sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed pulseaudio
sudo pacman -S --noconfirm --needed jack2

sudo pacman -S --noconfirm --needed gnome-bluetooth blueberry
sudo systemctl enable bluetooth.service

echo "Reboot now"
