#!/bin/bash

sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm --needed libx11
sudo pacman -S --noconfirm --needed libxft
sudo pacman -S --noconfirm --needed libxinerama
sudo pacman -S --noconfirm --needed freetype2
sudo pacman -S --noconfirm --needed fontconfig

cd ~
mkdir .suckless
cd .suckless

git clone https://github.com/ChrisTitusTech/dwm-titus.git dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu


cd dwm
make
sudo make clean install
cd..
cd st
make
sudo make clean install
cd ..
cd dmenu
make
sudo make clean install`
cd


# slstatus &

# # network applet
# # nm-applet &

# # background
# feh --bg-scale ~/.config/backgrounds/debdino.png &

# # compositor
# picom --config ~/.config/picom/picom.conf &

# # sxhkd
# sxhkd -c ~/.config/suckless/sxhkd/sxhkdrc &

# # Notifications
# dunst &

# # volume
# volumeicon &