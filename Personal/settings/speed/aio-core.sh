#!/bin/bash

echo '
[arcolinux_repo_iso]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

sudo pacman -Syy

sudo pacman -R xcursor-breeze --noconfirm


############################################################################
#                               GAMES
###########################################################################

#steam
#steam-native-runtime
#lutris
#sauerbraten
#xonotic

###########################################################################
#                           ARCOLINUX FOLDER
###########################################################################

sudo pacman -S --noconfirm --needed arcolinux-arc-kde
sudo pacman -S --noconfirm --needed arcolinux-arc-themes-nico-git
sudo pacman -S --noconfirm --needed arcolinux-bin-git
sudo pacman -S --noconfirm --needed arcolinux-common-git
sudo pacman -S --noconfirm --needed arcolinux-conky-collection-git
#sudo pacman -S --noconfirm --needed arcolinux-conky-collection-plasma-git
sudo pacman -S --noconfirm --needed arcolinux-cron-git
sudo pacman -S --noconfirm --needed arcolinux-docs-git
sudo pacman -S --noconfirm --needed arcolinux-faces-git
sudo pacman -S --noconfirm --needed arcolinux-fonts-git
sudo pacman -S --noconfirm --needed arcolinux-geany-git
sudo pacman -S --noconfirm --needed arcolinux-grub-theme-vimix-git
sudo pacman -S --noconfirm --needed arcolinux-hblock-git
sudo pacman -S --noconfirm --needed arcolinux-keyring
sudo pacman -S --noconfirm --needed arcolinux-kvantum-git
#sudo pacman -S --noconfirm --needed arcolinux-kvantum-lxqt-git
#sudo pacman -S --noconfirm --needed arcolinux-kvantum-plasma-git
sudo pacman -S --noconfirm --needed arcolinux-lightdm-gtk-greeter
#sudo pacman -S --noconfirm --needed arcolinux-lightdm-gtk-greeter-plasma
sudo pacman -S --noconfirm --needed arcolinux-lightdm-gtk-greeter-settings
sudo pacman -S --noconfirm --needed arcolinux-local-applications-git
sudo pacman -S --noconfirm --needed arcolinux-local-xfce4-git
sudo pacman -S --noconfirm --needed arcolinux-logo-git
#sudo pacman -S --noconfirm --needed arcolinux-lxqt-applications-add-git
#sudo pacman -S --noconfirm --needed arcolinux-lxqt-applications-hide-git
sudo pacman -S --noconfirm --needed arcolinux-mirrorlist-git
sudo pacman -S --noconfirm --needed arcolinux-neofetch-git
sudo pacman -S --noconfirm --needed arcolinux-nitrogen-git
sudo pacman -S --noconfirm --needed arcolinux-oblogout
sudo pacman -S --noconfirm --needed arcolinux-oblogout-themes-git
sudo pacman -S --noconfirm --needed arcolinux-obmenu-generator-git
#sudo pacman -S --noconfirm --needed arcolinux-obmenu-generator-minimal-git
#sudo pacman -S --noconfirm --needed arcolinux-obmenu-generator-xtended-git
sudo pacman -S --noconfirm --needed arcolinux-openbox-themes-git
sudo pacman -S --noconfirm --needed arcolinux-pipemenus-git
sudo pacman -S --noconfirm --needed arcolinux-plank-git
sudo pacman -S --noconfirm --needed arcolinux-plank-themes-git
sudo pacman -S --noconfirm --needed arcolinux-polybar-git
sudo pacman -S --noconfirm --needed arcolinux-qt5-git
#sudo pacman -S --noconfirm --needed arcolinux-qt5-plasma-git
sudo pacman -S --noconfirm --needed arcolinux-rofi-git
sudo pacman -S --noconfirm --needed arcolinux-rofi-themes-git
sudo pacman -S --noconfirm --needed arcolinux-root-git
sudo pacman -S --noconfirm --needed arcolinux-slim
sudo pacman -S --noconfirm --needed arcolinux-slimlock-themes-git
sudo pacman -S --noconfirm --needed arcolinux-system-config-git
#sudo pacman -S --noconfirm --needed arcolinux-systemd-services-git
sudo pacman -S --noconfirm --needed arcolinux-termite-themes-git
sudo pacman -S --noconfirm --needed arcolinux-tint2-git
sudo pacman -S --noconfirm --needed arcolinux-tint2-themes-git
sudo pacman -S --noconfirm --needed arcolinux-variety-git
sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git
sudo pacman -S --noconfirm --needed arcolinux-wallpapers-lxqt-dual-git
sudo pacman -S --noconfirm --needed arcolinux-xfce4-panel-profiles-git
sudo pacman -S --noconfirm --needed arcolinux-xmobar-git
sudo pacman -S --noconfirm --needed arcolinux-zsh-git

###########################################################################
#                           ARCOLINUX DESKTOP FOLDER
###########################################################################

sudo pacman -S --noconfirm --needed arcolinux-awesome-git
sudo pacman -S --noconfirm --needed arcolinux-bspwm-git
sudo pacman -S --noconfirm --needed arcolinux-budgie-git
sudo pacman -S --noconfirm --needed arcolinux-cinnamon-git
sudo pacman -S --noconfirm --needed arcolinux-deepin-git
sudo pacman -S --noconfirm --needed arcolinux-dwm-git
sudo pacman -S --noconfirm --needed arcolinux-enlightenment-git
sudo pacman -S --noconfirm --needed arcolinux-gnome-git
sudo pacman -S --noconfirm --needed arcolinux-herbstluftwm-git
sudo pacman -S --noconfirm --needed arcolinux-i3wm-git
sudo pacman -S --noconfirm --needed arcolinux-jwm-git
sudo pacman -S --noconfirm --needed arcolinux-lxqt-git
sudo pacman -S --noconfirm --needed arcolinux-mate-git
sudo pacman -S --noconfirm --needed arcolinux-openbox-git
#sudo pacman -S --noconfirm --needed arcolinux-openbox-xtended-git
#sudo pacman -S --noconfirm --needed arcolinux-plasma-git
sudo pacman -S --noconfirm --needed arcolinux-plasma-nemesis-git
sudo pacman -S --noconfirm --needed arcolinux-qtile-git
sudo pacman -S --noconfirm --needed arcolinux-xfce-git
sudo pacman -S --noconfirm --needed arcolinux-xmonad-polybar-git
#sudo pacman -S --noconfirm --needed arcolinux-xmonad-xmobar-git

###########################################################################
#                           ARCOLINUX CONFIG FOLDER
###########################################################################

sudo pacman -S --noconfirm --needed arcolinux-config-git

###########################################################################
#                           ARCOLINUX DCONF FOLDER
###########################################################################

sudo pacman -S --noconfirm --needed arcolinux-dconf-git

###########################################################################
#                                DESKTOP SPECIFIC
###########################################################################

sudo pacman -S --noconfirm --needed i3status
sudo pacman -S --noconfirm --needed i3blocks
sudo pacman -S --noconfirm --needed i3-gaps
sudo pacman -S --noconfirm --needed gtk2-perl
sudo pacman -S --noconfirm --needed obkey
sudo pacman -S --noconfirm --needed obmenu3
sudo pacman -S --noconfirm --needed obmenu-generator
sudo pacman -S --noconfirm --needed obconf
sudo pacman -S --noconfirm --needed openbox
sudo pacman -S --noconfirm --needed perl-linux-desktopfiles
sudo pacman -S --noconfirm --needed xfce4
sudo pacman -S --noconfirm --needed xfce4-goodies
sudo pacman -S --noconfirm --needed awesome
sudo pacman -S --noconfirm --needed vicious
sudo pacman -S --noconfirm --needed bspwm
sudo pacman -S --noconfirm --needed sxhkd
sudo pacman -S --noconfirm --needed xdo
sudo pacman -S --noconfirm --needed sutils-git
sudo pacman -S --noconfirm --needed xtitle-git
sudo pacman -S --noconfirm --needed herbstluftwm
sudo pacman -S --noconfirm --needed i3-gaps
sudo pacman -S --noconfirm --needed i3status
sudo pacman -S --noconfirm --needed gtk2-perl
sudo pacman -S --noconfirm --needed obconf
sudo pacman -S --noconfirm --needed openbox
sudo pacman -S --noconfirm --needed qtile
sudo pacman -S --noconfirm --needed python-psutil
sudo pacman -S --noconfirm --needed xmonad
sudo pacman -S --noconfirm --needed xmonad-contrib
sudo pacman -S --noconfirm --needed xmonad-utils
sudo pacman -S --noconfirm --needed haskell-dbus
sudo pacman -S --noconfirm --needed xmonad-log
sudo pacman -S --noconfirm --needed polybar
sudo pacman -S --noconfirm --needed qt5-webchannel
sudo pacman -S --noconfirm --needed budgie-desktop
sudo pacman -S --noconfirm --needed budgie-extras
sudo pacman -S --noconfirm --needed gnome
sudo pacman -S --noconfirm --needed gnome-extra
sudo pacman -S --noconfirm --needed nautilus-image-converter
sudo pacman -S --noconfirm --needed gnome-mplayer
sudo pacman -S --noconfirm --needed gnome-multi-writer
sudo pacman -S --noconfirm --needed gnome-pie
sudo pacman -S --noconfirm --needed gnome-screensaver
sudo pacman -S --noconfirm --needed guake
sudo pacman -S --noconfirm --needed cinnamon
sudo pacman -S --noconfirm --needed nemo-fileroller
sudo pacman -S --noconfirm --needed cinnamon-translations
sudo pacman -S --noconfirm --needed mintlocale
sudo pacman -S --noconfirm --needed iso-flag-png
sudo pacman -S --noconfirm --needed gnome-terminal
sudo pacman -S --noconfirm --needed gnome-system-monitor
sudo pacman -S --noconfirm --needed deepin
sudo pacman -S --noconfirm --needed deepin-extra
sudo pacman -S --noconfirm --needed dtkwidget
sudo pacman -S --noconfirm --needed linux-headers
sudo pacman -S --noconfirm --needed gnome
sudo pacman -S --noconfirm --needed gnome-extra
sudo pacman -S --noconfirm --needed nautilus-image-converter
sudo pacman -S --noconfirm --needed gnome-mplayer
sudo pacman -S --noconfirm --needed gnome-multi-writer
sudo pacman -S --noconfirm --needed gnome-pie
sudo pacman -S --noconfirm --needed chrome-gnome-shell
sudo pacman -S --noconfirm --needed libappindicator-gtk3
sudo pacman -S --noconfirm --needed gnome-shell-extension-appindicator-git
sudo pacman -S --noconfirm --needed guake
sudo pacman -S --noconfirm --needed lxqt
sudo pacman -S --noconfirm --needed pavucontrol-qt
sudo pacman -S --noconfirm --needed xscreensaver
sudo pacman -S --noconfirm --needed lxqt-arc-dark-theme-git
sudo pacman -S --noconfirm --needed ksuperkey
sudo pacman -S --noconfirm --needed mate
sudo pacman -S --noconfirm --needed mate-extra
sudo pacman -S --noconfirm --needed mate-tweak
sudo pacman -S --noconfirm --needed mate-menu
sudo pacman -S --noconfirm --needed pasystray
sudo pacman -S --noconfirm --needed paprefs
sudo pacman -S --noconfirm --needed plasma-meta
sudo pacman -S --noconfirm --needed partitionmanager
sudo pacman -S --noconfirm --needed ktorrent
sudo pacman -S --noconfirm --needed kdeconnect
sudo pacman -S --noconfirm --needed packagekit-qt5
sudo pacman -S --noconfirm --needed systemd-kcm
sudo pacman -S --noconfirm --needed kde-applications-meta
sudo pacman -S --noconfirm --needed yakuake
sudo pacman -S --noconfirm --needed archiso

cp -rf /etc/skel/* ~
