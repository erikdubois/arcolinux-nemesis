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

remove_if_installed() {
    for pattern in "$@"; do
        # Find all installed packages that match the pattern (exact + variants)
        matches=$(pacman -Qq | grep "^${pattern}$\|^${pattern}-")
        
        if [ -n "$matches" ]; then
            for pkg in $matches; do
                echo "Removing package: $pkg"
                sudo pacman -Rs --noconfirm "$pkg"
            done
        else
            echo "No packages matching '$pattern' are installed."
        fi
    done
}


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

if command -v systemd-detect-virt &> /dev/null; then

  if ! systemd-detect-virt | grep -q "oracle"; then
    if pacman -Qi xf86-video-vmware &> /dev/null; then
      sudo pacman -Rs xf86-video-vmware --noconfirm
    fi
  fi

fi

remove_if_installed rofi-lbonn-wayland
remove_if_installed rofi-lbonn-wayland-git
remove_if_installed neofetch
remove_if_installed fastfetch
remove_if_installed yay
remove_if_installed paru
remove_if_installed picom
remove_if_installed lxappearance

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

  #keep the dependencies
  sudo pacman -R --noconfirm archlinux-tweak-tool-git  &>/dev/null
  sudo pacman -R --noconfirm archlinux-tweak-tool-dev-git  &>/dev/null
  sudo pacman -R --noconfirm arcolinux-keyring &>/dev/null
  sudo pacman -R --noconfirm arcolinux-mirrorlist-git  &>/dev/null

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing ArcoLinux packages"
  echo "########################################################################"
  tput sgr0
  echo

  remove_if_installed arcolinux-pipemenus-git
  remove_if_installed arcolinux-meta-sddm-themes

  remove_if_installed a-candy-beauty-icon-theme-git
  remove_if_installed adobe-source-han-sans-cn-fonts
  remove_if_installed adobe-source-han-sans-jp-fonts
  remove_if_installed adobe-source-han-sans-kr-fonts
  remove_if_installed archlinux-kernel-manager
  remove_if_installed arcolinux-alacritty-git
  remove_if_installed arcolinux-app-glade-git
  remove_if_installed arcolinux-arc-dawn-git
  remove_if_installed arcolinux-arc-kde
  remove_if_installed arcolinux-bin-git
  remove_if_installed arcolinux-bootloader-systemd-boot-git
  remove_if_installed arcolinux-config-all-desktops-git
  remove_if_installed arcolinux-cron-git
  remove_if_installed arcolinux-dconf-all-desktops-git
  remove_if_installed arcolinux-desktop-trasher-git
  remove_if_installed arcolinux-faces-git
  remove_if_installed arcolinux-fastfetch-git
  remove_if_installed arcolinux-fish-git
  remove_if_installed arcolinux-fonts-git
  remove_if_installed arcolinux-gtk-sardi-arc-git
  remove_if_installed arcolinux-hblock-git
  remove_if_installed arcolinux-hyfetch-git
  remove_if_installed arcolinux-kvantum-git
  remove_if_installed arcolinux-local-applications-all-hide-git
  remove_if_installed arcolinux-local-applications-git
  remove_if_installed arcolinux-local-xfce4-git
  remove_if_installed arcolinux-logo-git
  remove_if_installed arcolinux-meta-log
  remove_if_installed arcolinux-neofetch-git
  remove_if_installed arcolinux-openbox-themes-git
  remove_if_installed arcolinux-pacman-git
  remove_if_installed arcolinux-paleofetch-git
  remove_if_installed arcolinux-paru-git
  remove_if_installed arcolinux-plank-git
  remove_if_installed arcolinux-plank-themes-git
  remove_if_installed arcolinux-polybar-git
  remove_if_installed arcolinux-powermenu-git
  remove_if_installed arcolinux-qt5-git
  remove_if_installed arcolinux-reflector-simple-git
  remove_if_installed arcolinux-rofi-git
  remove_if_installed arcolinux-rofi-themes-git
  remove_if_installed arcolinux-root-git
  remove_if_installed arcolinux-sddm-simplicity-git
  remove_if_installed arcolinux-system-config-git
  remove_if_installed arcolinuxd-system-config-git
  remove_if_installed arcolinux-systemd-services-git
  remove_if_installed arcolinux-teamviewer
  remove_if_installed arcolinux-termite-themes-git
  remove_if_installed arcolinux-variety-autostart-git
  remove_if_installed arcolinux-volumeicon-git
  remove_if_installed arcolinux-wallpapers-git
  remove_if_installed arcolinux-wallpapers-candy-git
  remove_if_installed arcolinux-welcome-app-git
  remove_if_installed arcolinuxd-welcome-app-git
  remove_if_installed arcolinux-xfce-panel-profiles-git
  remove_if_installed arcolinux-zsh-git
  remove_if_installed arconet-variety-config
  remove_if_installed arcopro-wallpapers
  remove_if_installed arconet-wallpapers
  remove_if_installed arconet-xfce
  remove_if_installed sofirem-git

  remove_if_installed simplicity-sddm-theme-git

  if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then
    remove_if_installed arcolinux-plasma-keybindings-git
    remove_if_installed arcolinux-plasma-servicemenus-git
    remove_if_installed arcolinux-plasma-theme-candy-beauty-arc-dark-git
    remove_if_installed arcolinux-plasma-theme-candy-beauty-nordic-git
    remove_if_installed arcolinux-gtk-surfn-plasma-dark-git
  fi

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing 3th party packages on ArcoLinux"
  echo "########################################################################"
  tput sgr0
  echo

  remove_if_installed bibata-cursor-theme-bin
  remove_if_installed fastfetch
  remove_if_installed mintstick-git
  remove_if_installed nomacs-qt6-git
  remove_if_installed rate-mirrors-bin
  remove_if_installed xfce4-artwork

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

# when on Ezarcher - remove
if grep -q "ezarch" /etc/os-release; then

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for Ezarch"
  echo "##############################################################"
  tput sgr0
  echo

  # I do not want the firewall
  sudo systemctl disable firewalld
  remove_if_installed firewalld

  remove_if_installed abiword

  echo
  tput setaf 3
  echo "##############################################################"
  echo "################### Software removed"
  echo "##############################################################"
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
  remove_if_installed firewalld

  # we will get the -git version and also paru-git
  remove_if_installed yay

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
  echo "############### Removing touchpad"
  echo "##############################################################"
  tput sgr0
  echo
  sudo rm /etc/X11/xorg.conf.d/30-touchpad.conf

  echo
  tput setaf 3
  echo "##############################################################"
  echo "############### Removing software for Garuda"
  echo "##############################################################"
  tput sgr0
  echo

  remove_if_installed garuda-common-settings
  
  remove_if_installed abiword
  remove_if_installed audacity
  remove_if_installed blueman
  remove_if_installed celluloid
  remove_if_installed fastfetch
  remove_if_installed garuda-browser-settings 
  remove_if_installed garuda-fish-config
  remove_if_installed garuda-icons
  remove_if_installed garuda-wallpapers
  remove_if_installed garuda-xfce-settings
  remove_if_installed geary
  remove_if_installed gestures
  remove_if_installed gtkhash
  remove_if_installed linux-wifi-hotspot garuda-network-assistant
  remove_if_installed modemmanager modem-manager-gui networkmanager-support
  remove_if_installed neofetch
  remove_if_installed onboard
  remove_if_installed paru
  remove_if_installed pitivi
  remove_if_installed redshift
  remove_if_installed transmission-gtk
  remove_if_installed veracrypt
  remove_if_installed vim vim-runtime
  remove_if_installed xfburn

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
  remove_if_installed firewalld
  remove_if_installed imagewriter
  remove_if_installed surfn-icons
  remove_if_installed grml-zsh-config

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
  echo "############### Removing software for Archcraft - FREE ISO"
  echo "############### Choosing only BSPWM during installation"
  echo "##############################################################"
  tput sgr0
  echo

  sudo rm -r /etc/skel/.config/*
  sudo rm /etc/skel/.dmrc
  sudo rm /etc/skel/.face
  sudo rm /etc/skel/.gtkrc-2.0

  remove_if_installed archcraft-skeleton
  remove_if_installed archcraft-omz
  remove_if_installed archcraft-skeleton
  remove_if_installed archcraft-openbox
  remove_if_installed archcraft-bspwm
  remove_if_installed archcraft-gtk-theme-arc
  remove_if_installed archcraft-config-qt
  remove_if_installed archcraft-neofetch
  remove_if_installed archcraft-arandr
  remove_if_installed simplescreenrecorder
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

  remove_if_installed big-skel

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

  sudo pacman -Rdd --noconfirm v4l-utils

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

  remove_if_installed cachyos-kernel-manager

  remove_if_installed btrfs-progs
  remove_if_installed cachy-browser
  remove_if_installed cachyos-fish-config fastfetch
  remove_if_installed cachyos-hello
  remove_if_installed cachyos-micro-settings 
  remove_if_installed cachyos-packageinstaller
  remove_if_installed cachyos-rate-mirrors
  remove_if_installed cachyos-wallpapers
  remove_if_installed cachyos-zsh-config
  remove_if_installed fastfetch
  remove_if_installed octopi
  remove_if_installed paru
  remove_if_installed ufw

  # for icons in chadwm
  remove_if_installed noto-color-emoji-fontconfig
  remove_if_installed noto-fonts-cjk
  remove_if_installed ttf-meslo-nerd


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

  remove_if_installed manjaro-xfce-settings

  echo
  tput setaf 2
  echo "##############################################################"
  echo "################### Software on Manjaro removed"
  echo "##############################################################"
  tput sgr0
  echo

fi


# when on Artix xfce - remove conflicting files - xfce iso is default
if grep -q "artix" /etc/os-release; then
  echo
  tput setaf 2
  echo "##############################################################"
  echo "####### Removing software for Artix"
  echo "##############################################################"
  tput sgr0
  echo

  remove_if_installed artix-qt-presets
  remove_if_installed artix-gtk-presets
  remove_if_installed artix-desktop-presets

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
