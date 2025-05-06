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

echo
tput setaf 2
echo "##############################################################"
echo "################### Start of the removal process"
echo "##############################################################"
tput sgr0
echo

echo
tput setaf 3
echo "##############################################################"
echo "################### Move configs for all - backup"
echo "##############################################################"
tput sgr0
echo

# always put the current .bashrc .zshrc away
if [ -f /etc/skel/.bashrc ]; then
  sudo mv -v /etc/skel/.bashrc /etc/skel/.bashrc-nemesis
fi

if [ -f /etc/skel/.zshrc ]; then
  sudo mv -v /etc/skel/.zshrc /etc/skel/.zshrc-nemesis
fi

echo
tput setaf 3
echo "########################################################################"
echo "######## Removing the driver for xf86-video-vmware if possible"
echo "########################################################################"
tput sgr0
echo

if ! systemd-detect-virt | grep -q "oracle"; then
  if pacman -Qi xf86-video-vmware &> /dev/null; then
    sudo pacman -Rs xf86-video-vmware --noconfirm
  fi
fi


sudo pacman -R rofi-lbonn-wayland --noconfirm
sudo pacman -R rofi-lbonn-wayland-git --noconfirm

# when on any ArcoLinux ISO


if [[ -f /etc/dev-rel ]]; then
  echo
  tput setaf 3
  echo "##############################################################"
  echo "####### Removing software on ArcoLinux ISOs"
  echo "##############################################################"
  tput sgr0
  echo

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Launch of get-me-started - kernels - conkys - broadcom/realtek"
  echo "########################################################################"
  tput sgr0
  echo
  sh get-me-started

  # order is important - dependencies
  
  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing the Arch Linux Tweak Tool"
  echo "######## Removing arcolinux-keyring"
  echo "######## Removing arcolinux-mirrorlist-git"
  echo "########################################################################"
  tput sgr0
  echo

  sudo pacman -Rns --noconfirm archlinux-tweak-tool-git

  sudo pacman -Rs --noconfirm arcolinux-keyring
  sudo pacman -Rs --noconfirm arcolinux-mirrorlist-git

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing ArcoLinux packages"
  echo "########################################################################"
  tput sgr0
  echo

  sudo pacman -Rs --noconfirm arcolinux-pipemenus-git

  sudo pacman -Rs --noconfirm a-candy-beauty-icon-theme-git
  sudo pacman -Rs --noconfirm adobe-source-han-sans-cn-fonts
  sudo pacman -Rs --noconfirm adobe-source-han-sans-jp-fonts
  sudo pacman -Rs --noconfirm adobe-source-han-sans-kr-fonts
  sudo pacman -Rs --noconfirm archlinux-kernel-manager
  sudo pacman -Rs --noconfirm arcolinux-app-glade-git
  sudo pacman -Rs --noconfirm arcolinux-arc-dawn-git
  sudo pacman -Rs --noconfirm arcolinux-arc-kde
  sudo pacman -Rs --noconfirm arcolinux-dconf-all-desktops-git
  sudo pacman -Rs --noconfirm arcolinux-desktop-trasher-git
  sudo pacman -Rs --noconfirm arcolinux-faces-git
  sudo pacman -Rs --noconfirm arcolinux-fish-git
  sudo pacman -Rs --noconfirm arcolinux-fonts-git
  sudo pacman -Rs --noconfirm arcolinux-hblock-git
  sudo pacman -Rs --noconfirm arcolinux-kvantum-git
  sudo pacman -Rs --noconfirm arcolinux-local-applications-all-hide-git
  sudo pacman -Rs --noconfirm arcolinux-local-applications-git
  sudo pacman -Rs --noconfirm arcolinux-local-xfce4-git
  sudo pacman -Rs --noconfirm arcolinux-logo-git
  sudo pacman -Rs --noconfirm arcolinux-meta-log
  sudo pacman -Rs --noconfirm arcolinux-root-git
  sudo pacman -Rs --noconfirm arcolinux-sddm-simplicity-git
  sudo pacman -Rs --noconfirm arcolinux-systemd-services-git
  sudo pacman -Rs --noconfirm arcolinux-wallpapers-git
  sudo pacman -Rs --noconfirm arcolinux-welcome-app-git
  sudo pacman -Rs --noconfirm arcolinux-xfce-panel-profiles-git
  sudo pacman -Rs --noconfirm arcolinux-zsh-git
  sudo pacman -Rs --noconfirm arconet-variety-config
  sudo pacman -Rs --noconfirm arconet-wallpapers
  sudo pacman -Rs --noconfirm arconet-xfce
  sudo pacman -Rs --noconfirm sofirem-git

  if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then
    sudo pacman -Rs --noconfirm arcolinux-plasma-keybindings-git
    sudo pacman -Rs --noconfirm arcolinux-plasma-servicemenus-git
    sudo pacman -Rs --noconfirm arcolinux-plasma-theme-candy-beauty-arc-dark-git
    sudo pacman -Rs --noconfirm arcolinux-plasma-theme-candy-beauty-nordic-git
    sudo pacman -Rs --noconfirm arcolinux-gtk-surfn-plasma-dark-git
  fi

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing 3th party packages on ArcoLinux"
  echo "########################################################################"
  tput sgr0
  echo

  sudo pacman -Rs --noconfirm bibata-cursor-theme-bin
  sudo pacman -Rs --noconfirm fastfetch
  sudo pacman -Rs --noconfirm mintstick-git
  sudo pacman -Rs --noconfirm nomacs-qt6-git
  sudo pacman -Rs --noconfirm rate-mirrors-bin
  sudo pacman -Rs --noconfirm xfce4-artwork

  tput setaf 3
  echo "##############################################################"
  echo "################### Software removal for ArcoLinux done"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on Arch Linux - remove conflicting files
if grep -q "Arch Linux" /etc/os-release && [ ! -e /bootloader ]; then

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Nothing to do"
  echo "########################################################################"
  tput sgr0
  echo

fi

# when on EOS - remove
if grep -q "EndeavourOS" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for EOS"
  echo "##############################################################"
  tput sgr0
  echo

  # I do not want the firewall
  sudo systemctl disable firewalld
  sudo pacman -Rs --noconfirm firewalld

  # we will get the -git version and also paru-git
  sudo pacman -Rs --noconfirm yay

  echo
  tput setaf 3
  echo "##############################################################"
  echo "################### Software removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on Garuda - remove conflicting files

if grep -q "Garuda" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing btrfs pacman hooks"
  echo "##############################################################"
  tput sgr0
  echo
  sudo rm /etc/systemd/system/timers.target.wants/btrfs*

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for Garuda"
  echo "##############################################################"
  tput sgr0
  echo
  sudo pacman -R --noconfirm blueman
  sudo pacman -R --noconfirm garuda-xfce-settings
  sudo pacman -R --noconfirm garuda-common-settings
  sudo pacman -R --noconfirm garuda-bash-config
  sudo pacman -R --noconfirm garuda-fish-config
  sudo pacman -R --noconfirm garuda-icons
  sudo pacman -R --noconfirm garuda-starship-prompt
  sudo pacman -R --noconfirm garuda-wallpapers
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
  sudo pacman -Rdd --noconfirm modemmanager modem-manager-gui
  sudo pacman -Rdd --noconfirm linux-wifi-hotspot

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on Garuda removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on Archman - remove conflicting files

if grep -q "Archman" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for Archman"
  echo "##############################################################"
  tput sgr0

  sudo systemctl disable firewalld
  sudo pacman -Rs --noconfirm firewalld
  sudo pacman -Rs --noconfirm imagewriter
  sudo pacman -Rs --noconfirm surfn-icons
  sudo pacman -Rs --noconfirm grml-zsh-config

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
  echo "##############################################################"
  echo "################### Software on Archman removed"
  echo "##############################################################"
  tput sgr0
  echo

fi


# when on Archcraft - remove conflicting files
if grep -q "archcraft" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for Archcraft"
  echo "##############################################################"
  tput sgr0
  echo

  sudo rm -r /etc/skel/.config/*
  sudo rm /etc/skel/.dmrc
  sudo rm /etc/skel/.face
  sudo rm /etc/skel/.gtkrc-2.0

  sudo pacman -Rs --noconfirm archcraft-skeleton
  sudo pacman -Rs --noconfirm archcraft-omz
  sudo pacman -Rs --noconfirm archcraft-skeleton
  sudo pacman -Rs --noconfirm archcraft-openbox
  sudo pacman -Rs --noconfirm archcraft-gtk-theme-arc
  sudo pacman -Rs --noconfirm archcraft-config-qt

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on Archcraft removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on BigLinux - remove conflicting files
if grep -q "BigLinux" /etc/os-release; then
  echo
  tput setaf 2
  echo "##############################################################"
  echo "####### Removing software for BigLinux"
  echo "##############################################################"
  tput sgr0
  echo

  sudo pacman -Rs --noconfirm big-skel

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on Biglinux removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on RebornOS - remove conflicting files
if grep -q "RebornOS" /etc/os-release; then
  echo
  tput setaf 2
  echo "##############################################################"
  echo "####### Removing software for RebornOS"
  echo "##############################################################"
  tput sgr0
  echo

  sudo pacman -Rs parole --noconfirm

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on RebornOS removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on CachyOS - remove conflicting files

if grep -q "cachyos" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for CachyOS"
  echo "##############################################################"
  tput sgr0
  echo

  sudo pacman -Rs --noconfirm cachyos-fish-config
  sudo pacman -Rs --noconfirm fastfetch
  sudo pacman -Rs --noconfirm paru

  echo
  tput setaf 3
  echo "##############################################################"
  echo "################### Software removed"
  echo "##############################################################"
  tput sgr0
  echo

fi

# when on Manjaro - remove conflicting files - xfce iso is default
if grep -q "Manjaro" /etc/os-release; then
  echo
  tput setaf 2
  echo "##############################################################"
  echo "####### Removing software for Manjaro"
  echo "##############################################################"
  tput sgr0
  echo

  sudo pacman -Rs manjaro-xfce-settings --noconfirm

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on Manjaro removed"
  echo "##############################################################"
  tput sgr0
  echo

fi


echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
