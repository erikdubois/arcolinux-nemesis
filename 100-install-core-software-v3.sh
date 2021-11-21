#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

#software from Arch Linux repositories

#sudo pacman -S --noconfirm --needed autorandr
sudo pacman -S --noconfirm --needed flameshot-git
sudo pacman -S --noconfirm --needed discord
sudo pacman -S --noconfirm --needed nomacs
#sudo pacman -S --noconfirm --needed gitfiend
#sudo pacman -S --noconfirm --needed dropbox
sudo pacman -S --noconfirm --needed spotify
sudo pacman -S --noconfirm --needed telegram-desktop
sudo pacman -S --noconfirm --needed insync

#just of these two for youtube
sudo pacman -S --noconfirm --needed vivaldi-ffmpeg-codecs
#for netflix
sudo pacman -S --noconfirm --needed vivaldi-widevine
sudo pacman -S --noconfirm --needed vivaldi
sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed brave
sudo pacman -S --noconfirm --needed vlc

sudo pacman -S --noconfirm --needed sublime-text-4

sudo pacman -S --noconfirm --needed meld

sudo pacman -S --noconfirm --needed gitahead-bin

sudo pacman -S --noconfirm --needed the_platinum_searcher-bin

sudo pacman -S --noconfirm --needed wps-office
sudo pacman -S --noconfirm --needed ttf-wps-fonts
sudo pacman -S --noconfirm --needed wps-office-mime

#sudo pacman -S --noconfirm --needed arcolinux-meta-fun

sudo pacman -S --noconfirm --needed simplescreenrecorder

sudo pacman -S --noconfirm --needed arcolinux-candy-beauty-git
sudo pacman -S --noconfirm --needed ayu-theme
sudo pacman -S --noconfirm --needed arc-darkest-theme-git

sudo pacman -S --noconfirm --needed wd719x-firmware
sudo pacman -S --noconfirm --needed aic94xx-firmware
sudo pacman -S --noconfirm --needed upd72020x-fw

sudo pacman -S --noconfirm --needed pv

###############################################################################################

# Here we remove applications we do not want

sudo systemctl disable tlp.service
sudo pacman -Rs tlp --noconfirm

Sudo pacman -Rs broadcom-wl-dkms

echo "################################################################"
echo "################### core software installed"
echo "################################################################"
