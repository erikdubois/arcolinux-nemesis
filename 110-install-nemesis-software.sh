#!/bin/bash
#set -e
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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

#nemesis-repo added to /etc/pacman.conf

if grep -q nemesis_repo /etc/pacman.conf; then

  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### nemesis_repo is already in /etc/pacman.conf"
  echo "########################################################################"
  tput sgr0
  echo

else

  tput setaf 2
  echo "########################################################################"
  echo "################### nemesis_repo added to /etc/pacman.conf"
  echo "########################################################################"
  tput sgr0

echo '

[nemesis_repo]
SigLevel = Optional TrustedOnly
Server = https://erikdubois.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf
fi

sudo pacman -Sy

echo
tput setaf 2
echo "########################################################################"
echo "################### Installing software from nemesis_repo"
echo "########################################################################"
tput sgr0
echo

# reinstall because of release difference between ArcoLinux and Chaotic-Aur

if [ -f /usr/share/xsessions/xfce.desktop ]; then
  sudo pacman -S --noconfirm menulibre
  sudo pacman -S --noconfirm mugshot
fi

sudo pacman -S --noconfirm upd72020x-fw

# removing all plasma packages whenever possible
if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then
  sudo pacman -Rs --noconfirm arcolinux-plasma-keybindings-git
  sudo pacman -Rs --noconfirm arcolinux-plasma-servicemenus-git
  sudo pacman -Rs --noconfirm arcolinux-plasma-theme-candy-beauty-arc-dark-git
  sudo pacman -Rs --noconfirm arcolinux-plasma-theme-candy-beauty-nordic-git
  sudo pacman -Rs --noconfirm arcolinux-gtk-surfn-plasma-dark-git
fi

# removing all conflicting packages with edu-dot-files-git
if grep -q "arco" /etc/dev-rel && [ -f /etc/dev-rel ]; then
  sudo pacman -R --noconfirm arcolinux-bin-git
  sudo pacman -R --noconfirm arcolinux-system-config-git
  sudo pacman -R --noconfirm arcolinux-bootloader-systemd-boot-git
  sudo pacman -R --noconfirm arcolinux-config-all-desktops-git
  sudo pacman -R --noconfirm arcolinux-alacritty-git
  sudo pacman -R --noconfirm arcolinux-btop-git
  sudo pacman -R --noconfirm arcolinux-gtk-surfn-arc-git
  sudo pacman -R --noconfirm arcolinux-paru-git
  sudo pacman -R --noconfirm arcolinux-qt5-git
fi

sudo pacman -S --noconfirm --needed edu-dot-files-git
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed archlinux-logout-git
sudo pacman -S --noconfirm --needed edu-arc-dawn-git
sudo pacman -S --noconfirm --needed edu-arc-kde
sudo pacman -S --noconfirm --needed edu-hblock-git
sudo pacman -S --noconfirm --needed edu-rofi-git
sudo pacman -S --noconfirm --needed edu-rofi-themes-git
sudo pacman -S --noconfirm --needed edu-sddm-simplicity-git
sudo pacman -S --noconfirm --needed edu-shells-git
sudo pacman -S --noconfirm --needed edu-variety-config-git
sudo pacman -S --noconfirm --needed edu-xfce-git
sudo pacman -S --noconfirm --needed flameshot-git
sudo pacman -S --noconfirm --needed gitahead-git
sudo pacman -S --noconfirm --needed hardcode-fixer-git
sudo pacman -S --noconfirm --needed lastpass
sudo pacman -S --noconfirm --needed neo-candy-icons-git
sudo pacman -S --noconfirm --needed pamac-aur
sudo pacman -S --noconfirm --needed rofi-lbonn-wayland
sudo pacman -S --noconfirm --needed sparklines-git
sudo pacman -S --noconfirm --needed surfn-icons-git
sudo pacman -S --noconfirm --needed wttr

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo