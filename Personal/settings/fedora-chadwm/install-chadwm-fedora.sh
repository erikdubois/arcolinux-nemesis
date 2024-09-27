#!/usr/bin/bash
# Credits to D3xter on Discord
# getting dependencies to be able to build Chadwm
# had to run dos2unix on this file to remove the hidden \r
sudo dnf group install -y "C Development Tools and Libraries"
sudo dnf install -y fontawesome-fonts
sudo dnf install -y imlib2-devel
sudo dnf install -y libX11-devel
sudo dnf install -y libXft-devel
sudo dnf install -y libXinerama-devel
# applications to be used in Chadwm
sudo dnf install -y alacritty
sudo dnf install -y feh
sudo dnf install -y nitrogen
sudo dnf install -y picom
sudo dnf install -y rofi
sudo dnf install -y sxhkd
sudo dnf install -y dmenu
sudo dnf install -y thunar
sudo dnf install -y thunar-archive-plugin
sudo dnf install -y thunar-volman
# exit strategy - super + shift + x
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~
# getting the official code from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~
# overwriting the official code from ArcoLinux with my own
# see the UBUNTU folder for the scripts beneath
#cp run.sh  ~/.config/arco-chadwm/scripts
#cp picom.conf  ~/.config/arco-chadwm/picom
#cp config.def.h ~/.config/arco-chadwm/chadwm
#cp sxhkdrc  ~/.config/arco-chadwm/sxhkd
#cp bar.sh ~/.config/arco-chadwm/scripts
#[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
#cp uca.xml ~/.config/Thunar/
# building Chadwm
cd ~/.config/arco-chadwm/chadwm
sudo make install
# removing this package - it slows down terminals and thunar
#sudo dnf remove -y xdg-desktop-portal-gnome
echo
echo "################################################################"
echo "###### Chadwm is installed - reboot"
echo "################################################################"
echo
