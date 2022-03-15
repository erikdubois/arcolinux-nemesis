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
sudo pacman -S --noconfirm --needed arcolinux-fish-git
sudo pacman -S --noconfirm --needed cpuid
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
#sudo pacman -S --noconfirm --needed brave-bin
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

#nemesis-repo added to /etc/pacman.conf

if grep -q nemesis_repo /etc/pacman.conf; then
  echo "nemesis_repo is already in /etc/pacman.conf"
else
echo '

[nemesis_repo]
SigLevel = Optional TrustedOnly
Server = https://erikdubois.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf
fi

sudo pacman -Sy

sudo pacman -S --noconfirm --needed edu-candy-beauty-arc-git
sudo pacman -S --noconfirm --needed edu-candy-beauty-arc-mint-grey-git
sudo pacman -S --noconfirm --needed edu-candy-beauty-arc-mint-red-git
sudo pacman -S --noconfirm --needed edu-candy-beauty-tela-git
sudo pacman -S --noconfirm --needed edu-papirus-dark-tela-git
sudo pacman -S --noconfirm --needed edu-papirus-dark-tela-grey-git
sudo pacman -S --noconfirm --needed edu-vimix-dark-tela-git

echo "################################################################"
echo "################### core software installed"
echo "################################################################"

###############################################################################################

# when on Leftwm

if [ -f /usr/share/xsessions/leftwm.desktop ]; then
  sh ~/.config/leftwm/scripts/install-all-arcolinux-themes.sh
  sh ~/.config/leftwm/scripts/install-all-arcolinux-themes-peter.sh
fi

###############################################################################################

# when on Plasma

if [ -f /usr/bin/startplasma-x11 ]; then
  sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
fi


echo "################################################################"
echo "################### end"
echo "################################################################"