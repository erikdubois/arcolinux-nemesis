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

sudo pacman -Syyu --noconfirm

# when on Plasma

if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then

  echo
  tput setaf 3
  echo "################################################################"
  echo "################### Get my personal variety settings"
  echo "################################################################"
  tput sgr0
  echo

  sudo wget https://raw.githubusercontent.com/erikdubois/arcolinux-nemesis/master/Personal/settings/variety/variety.conf -O ~/.config/variety/variety.conf

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma 6 Software to remove"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -Rs broadcom-wl-dkms --noconfirm
  sudo pacman -Rs rtl8821cu-morrownr-dkms-git --noconfirm

  sudo pacman -R --noconfirm adobe-source-han-sans-cn-fonts
  sudo pacman -R --noconfirm adobe-source-han-sans-jp-fonts
  sudo pacman -R --noconfirm adobe-source-han-sans-kr-fonts

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma 6 Software to install"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed obs-studio
  # design for Thunar
  sudo pacman -S --noconfirm --needed arc-gtk-theme
  sudo pacman -S --noconfirm --needed arcolinux-plasma-theme-candy-beauty-arc-dark-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-theme-candy-beauty-nordic-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-theme-surfn-arc-dark-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-theme-surfn-nordic-git
  sudo pacman -S --noconfirm --needed discord
  sudo pacman -S --noconfirm --needed kio-admin
  sudo pacman -S --noconfirm --needed kwin-polonium
  sudo pacman -S --noconfirm --needed meld
  sudo pacman -S --noconfirm --needed pavucontrol
  sudo pacman -S --noconfirm --needed python-pywal
  sudo pacman -S --noconfirm --needed ripgrep
  sudo pacman -S --noconfirm --needed sublime-text-4
  sudo pacman -S --noconfirm --needed telegram-desktop
  sudo pacman -S --noconfirm --needed the_platinum_searcher-bin
  sudo pacman -S --noconfirm --needed thunar
  sudo pacman -S --noconfirm --needed thunar-archive-plugin
  sudo pacman -S --noconfirm --needed thunar-volman

  sudo pacman -S --noconfirm --needed arcolinux-plasma-keybindings-git

  cp /etc/skel/.config/kglobalshortcutsrc ~/.config/
  cp /etc/skel/.config/kglobalshortcutsrc-or ~/.config/

  sudo pacman -S --noconfirm --needed arcolinux-plasma-servicemenus-git

  if [ ! -d ~/.local/share/kio/servicemenus/ ]; then
    mkdir -p ~/.local/share/kio/servicemenus/
  fi
  
  cp -v /etc/skel/.local/share/kio/servicemenus/* ~/.local/share/kio/servicemenus/

  echo "Overwriting plasma settings here!"
  cp -rv $HOME/DATA/arcolinux-nemesis/Personal/settings/plasma6/.* ~

  if ! grep -q "wobblywindowsEnabled=true" $HOME/.config/kwinrc; then
  echo '

[Plugins]
wobblywindowsEnabled=true' | sudo tee -a ~/.config/kwinrc
  fi

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo