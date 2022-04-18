#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website : https://www.erikdubois.be
# Website : https://www.alci.online
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

# when on EOS

if grep -q "EndeavourOS" /etc/os-release; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Installing/removing software for EOS"
  echo "################################################################"
  tput sgr0
  echo
  sudo pacman -S --noconfirm --needed alacritty
  sudo pacman -S --noconfirm --needed arcolinux-alacritty-git
  sudo pacman -S --noconfirm --needed arcolinux-hblock-git
  sudo pacman -S --noconfirm --needed arcolinux-logout-git
  sudo pacman -S --noconfirm --needed arcolinux-paru-git
  sudo pacman -S --noconfirm --needed arcolinux-root-git
  #sudo pacman -S --noconfirm --needed arcolinux-system-config-git
  sudo pacman -S --noconfirm --needed arcolinux-system-config-dev-git  
  #sudo pacman -S --noconfirm --needed lsb-release
  sudo pacman -S --noconfirm --needed arcolinux-tweak-tool-git
  sudo pacman -S --noconfirm --needed arcolinux-variety-git
  sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git
  sudo pacman -S --noconfirm --needed arcolinux-zsh-git
  sudo pacman -S --noconfirm --needed avahi
  sudo systemctl enable avahi-daemon.service
  sudo pacman -S --noconfirm --needed bat
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed expac
  sudo pacman -S --noconfirm --needed feh
  sudo pacman -S --noconfirm --needed gvfs-smb
  sudo pacman -S --noconfirm --needed hardcode-fixer-git
  sudo pacman -S --noconfirm --needed hw-probe
  sudo pacman -S --noconfirm --needed man-db
  sudo pacman -S --noconfirm --needed man-pages  
  sudo pacman -S --noconfirm --needed meld
  sudo pacman -S --noconfirm --needed neofetch
  sudo pacman -S --noconfirm --needed nss-mdns
  sudo pacman -S --noconfirm --needed oh-my-zsh-git
  sudo pacman -S --noconfirm --needed paru-bin
  sudo pacman -S --noconfirm --needed rate-mirrors-bin
  sudo pacman -S --noconfirm --needed ripgrep
  sudo pacman -S --noconfirm --needed variety
  sudo pacman -S --noconfirm --needed yay-bin
  sudo pacman -S --noconfirm --needed zsh
  sudo pacman -S --noconfirm --needed zsh-completions
  sudo pacman -S --noconfirm --needed zsh-syntax-highlighting

  sudo pacman -S --noconfirm --needed adobe-source-sans-fonts
  sudo pacman -S --noconfirm --needed awesome-terminal-fonts
  sudo pacman -S --noconfirm --needed noto-fonts
  sudo pacman -S --noconfirm --needed ttf-bitstream-vera
  sudo pacman -S --noconfirm --needed ttf-dejavu
  sudo pacman -S --noconfirm --needed ttf-droid
  sudo pacman -S --noconfirm --needed ttf-hack
  sudo pacman -S --noconfirm --needed ttf-inconsolata
  sudo pacman -S --noconfirm --needed ttf-liberation
  sudo pacman -S --noconfirm --needed ttf-roboto
  sudo pacman -S --noconfirm --needed ttf-roboto-mono
  sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family

echo
tput setaf 2
echo "################################################################"
echo "################### SKEL !!!"
echo "################################################################"
tput sgr0
echo

cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
cp -arf /etc/skel/. ~

echo
tput setaf 2
echo "################################################################"
echo "################### Software installed"
echo "################################################################"
tput sgr0
echo
