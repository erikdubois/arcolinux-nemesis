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

echo
tput setaf 3
echo "######################################################"
echo "################### Remove software for all"
echo "######################################################"
tput sgr0
echo
sudo pacman -R --noconfirm arcolinux-chadwm-git
sudo pacman -R --noconfirm arcolinux-rofi-git
sudo pacman -R --noconfirm arcolinux-rofi-themes-git
sudo pacman -R --noconfirm arcolinux-arc-dawn-git
sudo pacman -R --noconfirm arcolinux-arc-kde
sudo pacman -R --noconfirm arcolinux-plasma-theme-candy-beauty-arc-dark-git
sudo pacman -R --noconfirm arcolinux-plasma-theme-candy-beauty-nordic-git
sudo pacman -R --noconfirm arcolinux-plasma-keybindings-git
sudo pacman -R --noconfirm arcolinux-plasma-servicemenus-git
sudo pacman -R --noconfirm arcolinux-sddm-simplicity-git
sudo pacman -R --noconfirm arcolinux-fish-git
sudo pacman -R --noconfirm arcolinux-hblock-git
sudo pacman -R --noconfirm arcolinux-root-git
sudo pacman -R --noconfirm arcolinux-zsh-git
sudo pacman -R --noconfirm arconet-variety-config
sudo pacman -R --noconfirm speedtest-cli-git
sudo pacman -R --noconfirm arconet-xfce
sudo pacman -R --noconfirm mintstick-git
sudo pacman -R --noconfirm fastfetch
sudo pacman -Rs --noconfirm memtest86+
sudo pacman -Rs --noconfirm memtest86+-efi
sudo pacman -Rs --noconfirm nomacs-qt6-git
sudo pacman -Rs --noconfirm hardinfo-gtk3
sudo pacman -Rs --noconfirm paru-bin
sudo pacman -Rs --noconfirm yay-bin
sudo pacman -Rs --noconfirm bibata-cursor-theme-bin
sudo pacman -Rs broadcom-wl-dkms --noconfirm
sudo pacman -Rs rtl8821cu-morrownr-dkms-git --noconfirm
sudo pacman -Rs --noconfirm archinstall
sudo pacman -Rs pragha --noconfirm
sudo pacman -Rs rate-mirrors-bin --noconfirm
sudo pacman -Rs lftp --noconfirm
sudo pacman -Rs xf86-video-amdgpu --noconfirm
sudo pacman -Rs xf86-video-fbdev --noconfirm
sudo pacman -Rs xf86-video-openchrome --noconfirm
if pacman -Qi xf86-video-vmware &> /dev/null; then
  sudo pacman -Rs xf86-video-vmware --noconfirm
fi
sudo pacman -Rs xf86-video-ati --noconfirm
sudo pacman -Rs xf86-video-nouveau --noconfirm
sudo pacman -Rs xf86-video-vesa --noconfirm
sudo pacman -Rs --noconfirm xfce4-artwork
sudo rm -rf /usr/share/backgrounds/xfce

sudo pacman -Rs --noconfirm adobe-source-han-sans-cn-fonts
sudo pacman -Rs --noconfirm adobe-source-han-sans-jp-fonts
sudo pacman -Rs --noconfirm adobe-source-han-sans-kr-fonts

sudo pacman -Rs --noconfirm a-candy-beauty-icon-theme-git

echo
tput setaf 3
echo "######################################################"
echo "################### Remove configs for all"
echo "######################################################"
tput sgr0
echo

# always put the current .bashrc .zshrc away
if [ -f /etc/skel/.bashrc ]; then
  sudo mv /etc/skel/.bashrc /etc/skel/.bashrc-old
fi

if [ -f /etc/skel/.zshrc ]; then
  sudo mv /etc/skel/.zshrc /etc/skel/.zshrc-old
fi

# when on ARCOLINUX - remove conflicting files

if grep -q "arco" /etc/dev-rel; then
  echo
  tput setaf 2
  echo "######################################################"
  echo "####### Removing software for ArcoLinux"
  echo "######################################################"
  tput sgr0
  echo

  # first depends on gone
  sudo pacman -R --noconfirm arcolinux-pipemenus-git
  sudo pacman -R --noconfirm archlinux-tweak-tool-git

  sudo pacman -R --noconfirm arcolinux-app-glade-git
  sudo pacman -R --noconfirm arcolinux-common-git
  sudo pacman -R --noconfirm arcolinux-dconf-all-desktops-git
  sudo pacman -R --noconfirm arcolinux-desktop-trasher-git
  sudo pacman -R --noconfirm arcolinux-faces-git
  sudo pacman -R --noconfirm arcolinux-fonts-git
  sudo pacman -R --noconfirm arcolinux-keyring
  sudo pacman -R --noconfirm arcolinux-kvantum-git
  sudo pacman -R --noconfirm arcolinux-local-applications-all-hide-git
  sudo pacman -R --noconfirm arcolinux-local-applications-git
  sudo pacman -R --noconfirm arcolinux-local-xfce4-git
  sudo pacman -R --noconfirm arcolinux-logo-git
  sudo pacman -R --noconfirm arcolinux-meta-log
  sudo pacman -R --noconfirm arcolinux-mirrorlist-git
  sudo pacman -R --noconfirm arcolinux-systemd-services-git
  sudo pacman -R --noconfirm arcolinux-wallpapers-git
  sudo pacman -R --noconfirm arcolinux-welcome-app-git
  sudo pacman -R --noconfirm arcolinux-xfce-panel-profiles-git

  sudo pacman -R --noconfirm arconet-wallpapers

  sudo pacman -R --noconfirm archlinux-kernel-manager
  sudo pacman -R --noconfirm ufetch-arco-git
  
  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on Arch Linux - remove conflicting files
if grep -q "archlinux" /etc/os-release; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for Arch"
  echo "######################################################"
  tput sgr0
  echo


  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on EOS - remove conflicting files

if grep -q "EndeavourOS" /etc/os-release; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for EOS"
  echo "######################################################"
  tput sgr0
  echo
  if [ -f /etc/skel/.config/rofi/config.rasi ]; then
    sudo rm -v /etc/skel/.config/rofi/config.rasi
  fi   

  sudo systemctl disable firewalld
  sudo pacman -R --noconfirm firewalld

  sudo pacman -R --noconfirm yay

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on Garuda - remove conflicting files

if grep -q "Garuda" /etc/os-release; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for Garuda"
  echo "######################################################"
  tput sgr0
  echo

  sudo pacman -R --noconfirm blueman
  sudo pacman -R --noconfirm garuda-xfce-settings
  sudo pacman -R --noconfirm garuda-common-settings
  sudo pacman -R --noconfirm garuda-bash-config
  sudo pacman -R --noconfirm redshift
  sudo pacman -Rs --noconfirm transmission-gtk
  sudo pacman -Rs --noconfirm geary
  sudo pacman -Rs --noconfirm celluloid
  sudo pacman -Rs --noconfirm pitivi
  sudo pacman -Rs --noconfirm audacity
  sudo pacman -Rs --noconfirm xfburn
  sudo pacman -Rs --noconfirm abiword
  sudo pacman -Rs --noconfirm veracrypt
  sudo pacman -Rs --noconfirm gtkhash
  sudo pacman -Rs --noconfirm onboard
  sudo pacman -Rs --noconfirm vim vim-runtime
  sudo pacman -Rs --noconfirm gestures
  sudo pacman -Rs --noconfirm pinta
  sudo pacman -Rdd --noconfirm hblock
  sudo pacman -Rdd --noconfirm modemmanager modem-manager-gui
  sudo pacman -Rdd --noconfirm linux-wifi-hotspot

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on Archman - remove conflicting files

if grep -q "Archman" /etc/os-release; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for Archman"
  echo "######################################################"
  tput sgr0

  sudo systemctl disable firewalld
  sudo pacman -R --noconfirm firewalld
  sudo pacman -R --noconfirm imagewriter
  sudo pacman -R --noconfirm surfn-icons
  sudo pacman -R --noconfirm grml-zsh-config

  sudo rm -r /etc/skel/.config/Thunar
  sudo rm -r /etc/skel/.config/xfce4

  sudo rm /etc/skel/.config/mimeapps.list
  sudo rm /etc/skel/.face
  sudo rm /etc/skel/.xinitrc

  sudo rm /etc/X11/xorg.conf.d/99-killX.conf
  sudo rm /etc/modprobe.d/disable-evbug.conf
  sudo rm /etc/modprobe.d/nobeep.conf

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi


# when on Archcraft - remove conflicting files
if grep -q "archcraft" /etc/os-release; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for Archcraft"
  echo "######################################################"
  tput sgr0
  echo

  sudo rm -r /etc/skel/.config/*
  sudo rm /etc/skel/.dmrc
  sudo rm /etc/skel/.face
  sudo rm /etc/skel/.gtkrc-2.0

  sudo pacman -R --noconfirm archcraft-skeleton
  sudo pacman -R --noconfirm archcraft-omz
  sudo pacman -R --noconfirm archcraft-skeleton
  sudo pacman -R --noconfirm archcraft-openbox
  sudo pacman -R --noconfirm archcraft-gtk-theme-arc
  sudo pacman -R --noconfirm archcraft-config-qt
  #sudo pacman -R --noconfirm archcraft-neofetch

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on BigLinux - remove conflicting files
if grep -q "BigLinux" /etc/os-release; then
  echo
  tput setaf 2
  echo "######################################################"
  echo "####### Removing software for BigLinux"
  echo "######################################################"
  tput sgr0
  echo

  sudo pacman -R --noconfirm big-skel

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on RebornOS - remove conflicting files
if grep -q "RebornOS" /etc/os-release; then
  echo
  tput setaf 2
  echo "######################################################"
  echo "####### Removing software for RebornOS"
  echo "######################################################"
  tput sgr0
  echo

  sudo pacman -Rs parole --noconfirm

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done"
echo "######################################################"
tput sgr0
echo
