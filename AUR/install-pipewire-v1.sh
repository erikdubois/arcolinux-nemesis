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

sudo pacman -S --noconfirm --needed pipewire
sudo pacman -S --noconfirm --needed pipewire-media-session
sudo pacman -S --noconfirm --needed pipewire-alsa
sudo pacman -Rdd --noconfirm jack2

# : removing jack2 breaks dependency 'jack' required by ffmpeg
# :: removing jack2 breaks dependency 'jack' required by ffmpeg4.4
# :: removing jack2 breaks dependency 'libjack.so=0-64' required by fluidsynth
# :: removing jack2 breaks dependency 'libjack.so=0-64' required by gst-plugins-good
# :: removing jack2 breaks dependency 'libjack.so=0-64' required by portaudio
# :: removing jack2 breaks dependency 'jack' required by simplescreenrecorder

sudo pacman -S --noconfirm --needed pipewire-jack
sudo pacman -S --noconfirm --needed pipewire-zeroconf



 
sudo pacman -R --noconfirm pulseaudio-equalizer-ladspa
sudo pacman -R --noconfirm pulseaudio-alsa
sudo pacman -R --noconfirm gnome-bluetooth blueberry
sudo pacman -R --noconfirm pulseaudio-bluetooth
sudo pacman -R --noconfirm pulseaudio



sudo pacman -S --noconfirm --needed pipewire-pulse
sudo pacman -S --noconfirm --needed blueberry
sudo pacman -S --noconfirm --needed pavucontrol
sudo systemctl enable bluetooth.service

exit 1

echo "Reboot now"
