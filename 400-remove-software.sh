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

echo
tput setaf 3
echo "######################################################"
echo "################### Remove software for all"
echo "######################################################"
tput sgr0
echo

sudo pacman -R --noconfirm archinstall
sudo pacman -Rs pragha --noconfirm
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
sudo pacman -R --noconfirm xfce4-artwork
sudo rm -rf /usr/share/backgrounds/xfce
sudo pacman -Rs broadcom-wl-dkms --noconfirm
sudo pacman -Rs rtl8821cu-morrownr-dkms-git --noconfirm

sudo pacman -R --noconfirm adobe-source-han-sans-cn-fonts
sudo pacman -R --noconfirm adobe-source-han-sans-jp-fonts
sudo pacman -R --noconfirm adobe-source-han-sans-kr-fonts

# always put the current .bashrc .zshrc away
if [ -f /etc/skel/.bashrc ]; then
  sudo mv /etc/skel/.bashrc /etc/skel/.bashrc-old
fi

if [ -f /etc/skel/.zshrc ]; then
  sudo mv /etc/skel/.zshrc /etc/skel/.zshrc-old
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

  echo "Nothing to remove"

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on CARLI - remove conflicting files

if [ -f /usr/local/bin/get-nemesis-on-carli ]; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Removing software for Carli"
  echo "######################################################"
  tput sgr0
  echo

  sudo pacman -R --noconfirm carli-xfce-config
  sudo pacman -R --noconfirm grml-zsh-config
  sudo pacman -R --noconfirm systemd-resolvconf

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on ARISER - remove conflicting files 

if [ -f /usr/local/bin/get-nemesis-on-ariser ]; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Removing software for ARISER"
  echo "######################################################"
  tput sgr0
  echo

  echo "Nothing to do"

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo 
fi

# when on ARCOLINUX - remove conflicting files

if grep -q "ArcoLinux" /etc/os-release; then
  echo
  tput setaf 2
  echo "######################################################"
  echo "####### Removing software for ArcoLinux"
  echo "######################################################"
  tput sgr0
  echo

  echo "Nothing to do"

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

  sudo systemctl disable firewalld
  sudo pacman -R --noconfirm firewalld

  sudo pacman -R --noconfirm arc-gtk-theme-eos
  sudo pacman -Rdd --noconfirm eos-settings-xfce4
  #sudo pacman -Rdd --noconfirm modemmanager modemmanager-qt
  sudo pacman -R --noconfirm yay

  # sudo rm -r /etc/skel/.config/Kvantum
  # sudo rm -r /etc/skel/.config/gtk-3.0
  # sudo rm -r /etc/skel/.config/variety
  # sudo rm -r /etc/skel/.config/Thunar
  # sudo rm -r /etc/skel/.config/xfce4
  sudo rm /etc/skel/.config/xfce4/panel/whiskermenu-7.rc

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on ALCI - remove conflicting files

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for ALCI"
  echo "######################################################"
  tput sgr0
  echo

  sudo rm /etc/skel/.Xresources
  sudo pacman -R --noconfirm amd-ucode
  sudo pacman -R --noconfirm b43-fwcutter
  sudo pacman -R --noconfirm broadcom-wl
  sudo pacman -R --noconfirm broadcom-wl-dkms  
  sudo pacman -Rs --noconfirm cloud-init
  sudo pacman -R --noconfirm darkhttpd
  sudo pacman -R --noconfirm dhcpcd
  sudo pacman -R --noconfirm ell  
  sudo pacman -R --noconfirm grml-zsh-config
  sudo pacman -R --noconfirm iwd
  sudo pacman -R --noconfirm kitty-terminfo
  sudo pacman -R --noconfirm lftp
  sudo pacman -R --noconfirm livecd-sounds
  sudo pacman -R --noconfirm lua53
  sudo pacman -R --noconfirm luit
  sudo pacman -R --noconfirm lynx
  sudo pacman -R --noconfirm mousepad
  sudo pacman -R --noconfirm nmap
  sudo pacman -R --noconfirm parole
  sudo pacman -R --noconfirm systemd-resolvconf
  sudo pacman -R --noconfirm xbitmaps
  sudo pacman -R --noconfirm xfburn
  sudo pacman -R --noconfirm xterm
  sudo pacman -Rs --noconfirm brltty
  sudo pacman -Rs --noconfirm espeak-ng
  sudo pacman -Rs --noconfirm espeakup

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


# when on SIERRA - remove conflicting files

if [ -f /usr/local/bin/get-nemesis-on-sierra ]; then

  echo
  tput setaf 2
  echo "######################################################"
  echo "############### Removing software for Sierra"
  echo "######################################################"
  tput sgr0
  echo

  sudo pacman -R --noconfirm amd-ucode
  sudo pacman -R --noconfirm b43-fwcutter
  sudo pacman -R --noconfirm broadcom-wl
  sudo pacman -R --noconfirm broadcom-wl-dkms  
  sudo pacman -Rs --noconfirm cloud-init
  sudo pacman -R --noconfirm darkhttpd
  sudo pacman -R --noconfirm dhcpcd
  sudo pacman -R --noconfirm ell  
  sudo pacman -R --noconfirm grml-zsh-config
  sudo pacman -R --noconfirm iwd
  sudo pacman -R --noconfirm kitty-terminfo
  sudo pacman -R --noconfirm lftp
  sudo pacman -R --noconfirm livecd-sounds
  sudo pacman -R --noconfirm lua53
  sudo pacman -R --noconfirm luit
  sudo pacman -R --noconfirm lynx
  sudo pacman -R --noconfirm mousepad
  sudo pacman -R --noconfirm nmap
  sudo pacman -R --noconfirm parole
  sudo pacman -R --noconfirm systemd-resolvconf
  sudo pacman -R --noconfirm xbitmaps
  sudo pacman -R --noconfirm xfburn
  sudo pacman -R --noconfirm xterm
  sudo pacman -Rs --noconfirm brltty
  sudo pacman -Rs --noconfirm espeak-ng
  sudo pacman -Rs --noconfirm espeakup

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
echo "################### Done"
echo "######################################################"
tput sgr0
echo

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

  sudo rm -r /etc/skel/.config/variety/variety.conf
  sudo pacman -R --noconfirm big-skel

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi

# when on BigLinux - remove conflicting files
if grep -q "RebornOS" /etc/os-release; then
  echo
  tput setaf 2
  echo "######################################################"
  echo "####### Removing software for RebornOS"
  echo "######################################################"
  tput sgr0
  echo

  sudo rm -r /etc/skel/.config/variety/variety.conf
  sudo pacman -Rs parole --noconfirm

  echo
  tput setaf 2
  echo "######################################################"
  echo "################### Software removed"
  echo "######################################################"
  tput sgr0
  echo

fi