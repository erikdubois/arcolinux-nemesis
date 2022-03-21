#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
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

echo
tput setaf 2
echo "################################################################"
echo "################### Software to install"
echo "################################################################"
tput sgr0
echo

if grep -q "Arch Linux" /etc/os-release; then
  if grep -q arcolinux_repo /etc/pacman.conf; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################ ArcoLinux repos are already in /etc/pacman.conf"
    echo "################################################################"
    tput sgr0
    echo
    else
    #get the keys and mirrors for ArcoLinux
    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Getting the keys and mirrors for ArcoLinux"
    echo "################################################################"
    tput sgr0
    echo
    sh arch/get-the-keys-and-repos.sh
    sudo pacman -Sy
  fi
fi

# when on Carli - remove conflicting files 

if grep -q "carli" /etc/os-release; then
  sudo pacman -R --noconfirm carli-xfce-config
  sudo pacman -R --noconfirm grml-zsh-config
  sudo pacman -R --noconfirm carli-neofetch
  sudo rm -f /etc/pacman.d/hooks/lsb-release.hook
  sudo pacman -R --noconfirm lsb-release
fi

# here we assume we are on anything Arch Linux based - ArcoLinux as a rule

sudo pacman -S --noconfirm --needed aic94xx-firmware
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed arc-darkest-theme-git
sudo pacman -S --noconfirm --needed arcolinux-arc-themes-2021-sky-git
sudo pacman -S --noconfirm --needed arcolinux-candy-beauty-git
sudo pacman -S --noconfirm --needed arcolinux-fish-git
sudo pacman -S --noconfirm --needed ayu-theme
sudo pacman -S --noconfirm --needed bibata-cursor-theme-bin
sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed cpuid
sudo pacman -S --noconfirm --needed discord
sudo pacman -S --noconfirm --needed file-roller
sudo pacman -S --noconfirm --needed flameshot-git
sudo pacman -S --noconfirm --needed gitahead-bin
sudo pacman -S --noconfirm --needed insync
sudo pacman -S --noconfirm --needed meld
sudo pacman -S --noconfirm --needed nomacs
sudo pacman -S --noconfirm --needed polkit-gnome
sudo pacman -S --noconfirm --needed pv
sudo pacman -S --noconfirm --needed simplescreenrecorder
sudo pacman -S --noconfirm --needed spotify
sudo pacman -S --noconfirm --needed sublime-text-4
sudo pacman -S --noconfirm --needed surfn-icons-git
sudo pacman -S --noconfirm --needed telegram-desktop
sudo pacman -S --noconfirm --needed the_platinum_searcher-bin
sudo pacman -S --noconfirm --needed ttf-wps-fonts
sudo pacman -S --noconfirm --needed upd72020x-fw
sudo pacman -S --noconfirm --needed vivaldi
sudo pacman -S --noconfirm --needed vivaldi-ffmpeg-codecs
sudo pacman -S --noconfirm --needed vivaldi-widevine
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed wd719x-firmware
sudo pacman -S --noconfirm --needed wps-office
sudo pacman -S --noconfirm --needed wps-office-mime

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

###############################################################################################

# when on Leftwm

if [ -f /usr/share/xsessions/leftwm.desktop ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Leftwm related applications"
  echo "################################################################"
  tput sgr0
  echo


  sh ~/.config/leftwm/scripts/install-all-arcolinux-themes.sh
  sh ~/.config/leftwm/scripts/install-all-arcolinux-themes-peter.sh
fi

###############################################################################################

# when on Plasma

if [ -f /usr/bin/startplasma-x11 ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Plasma related applications"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
  sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
fi

###############################################################################################


# when on Arch Linux

if grep -q "Arch Linux" /etc/os-release; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Installing software for Arch Linux - Any desktop"
  echo "################################################################"
  tput sgr0
  echo
  sudo pacman -S --noconfirm --needed alacritty
  sudo pacman -S --noconfirm --needed arcolinux-alacritty-git
  sudo pacman -S --noconfirm --needed arcolinux-hblock-git
  sudo pacman -S --noconfirm --needed arcolinux-logout-git
  sudo pacman -S --noconfirm --needed arcolinux-paru-git
  sudo pacman -S --noconfirm --needed arcolinux-root-git
  sudo pacman -S --noconfirm --needed arcolinux-system-config-git
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
  echo "################################################################"
  echo "Getting latest /etc/nsswitch.conf from ArcoLinux"
  echo "################################################################"
  echo
  sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
  sudo wget https://raw.githubusercontent.com/arcolinux/arcolinuxl-iso/master/archiso/airootfs/etc/nsswitch.conf -O $workdir/etc/nsswitch.conf

  # when on Plasma

  if [ -f /usr/bin/startplasma-x11 ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - Plasma"
    echo "################################################################"
    tput sgr0
    echo    
    sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
    sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
    sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
    sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git

  fi

  # when on Xfce4

  if [ -f /usr/share/xsessions/xfce.desktop ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - Xfce4"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed arcolinux-local-xfce4-git
    sudo pacman -S --noconfirm --needed sardi-icons
    sudo pacman -S --noconfirm --needed arcolinux-xfce-git
  fi

  # when on i3

  if [ -f /usr/share/xsessions/i3.desktop ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - i3wm"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed arcolinux-i3wm-git
    sudo pacman -S --noconfirm --needed arcolinux-local-xfce4-git
    sudo pacman -S --noconfirm --needed autotiling
    sudo pacman -S --noconfirm --needed lxappearance
    sudo pacman -S --noconfirm --needed nitrogen
    sudo pacman -S --noconfirm --needed picom
    sudo pacman -S --noconfirm --needed sardi-icons
    sudo pacman -S --noconfirm --needed thunar
    sudo pacman -S --noconfirm --needed thunar-archive-plugin
    sudo pacman -S --noconfirm --needed thunar-volman

  fi

  # when on Cinnamon

  if [ -f /usr/bin/cinnamon ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Cinnamon related applications"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed cinnamon-translations
    sudo pacman -S --noconfirm --needed gnome-terminal
    sudo pacman -S --noconfirm --needed gnome-system-monitor
    sudo pacman -S --noconfirm --needed gnome-screenshot
    sudo pacman -S --noconfirm --needed iso-flag-png
    sudo pacman -S --noconfirm --needed mintlocale
    sudo pacman -S --noconfirm --needed nemo-fileroller

  fi

  # when on Leftwm

  if [ -f /usr/bin/leftwm ]; then

    sh ~/.config/leftwm/scripts/install-all-arcolinux-themes.sh
    sh ~/.config/leftwm/scripts/install-all-arcolinux-themes-peter.sh

  fi

fi

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
