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
echo "################################################################"
echo "################### Remove software"
echo "################################################################"
tput sgr0
echo

# remove where ever we are

sudo pacman -R --noconfirm xfce4-artwork

sudo pacman -Rs broadcom-wl-dkms --noconfirm
sudo pacman -Rs xf86-video-amdgpu --noconfirm
sudo pacman -Rs xf86-video-fbdev --noconfirm
sudo pacman -Rs xf86-video-openchrome --noconfirm
if pacman -Qi xf86-video-vmware &> /dev/null; then
  sudo pacman -Rs xf86-video-vmware --noconfirm
fi
sudo pacman -Rs xf86-video-ati --noconfirm
sudo pacman -Rs xf86-video-nouveau --noconfirm
sudo pacman -Rs xf86-video-vesa --noconfirm

# when on Arch Linux - remove conflicting files

if grep -q "archlinux" /etc/os-release; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Removing software for Arch"
  echo "################################################################"
  tput sgr0

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi

# when on CARLI - remove conflicting files

if [ -f /usr/local/bin/get-nemesis-on-carli ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Removing software from Carli"
  echo "################################################################"
  tput sgr0
  echo
  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi  
  sudo pacman -R --noconfirm carli-xfce-config
  sudo pacman -R --noconfirm grml-zsh-config
  sudo pacman -R --noconfirm systemd-resolvconf

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi

# when on ARISER - remove conflicting files 

if [ -f /usr/local/bin/get-nemesis-on-ariser ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Removing software from ARISER"
  echo "################################################################"
  tput sgr0
  echo

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo 
fi

# when on ARCOLINUX - remove conflicting files

if grep -q "ArcoLinux" /etc/os-release; then
  echo
  tput setaf 2
  echo "################################################################"
  echo "#######Software to remove from an ArcoLinux installation"
  echo "################################################################"
  tput sgr0
  echo

  #sudo systemctl disable tlp.service
  #sudo pacman -Rs tlp --noconfirm

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi

# when on EOS - remove conflicting files

if grep -q "EndeavourOS" /etc/os-release; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Removing software for EOS"
  echo "################################################################"
  tput sgr0

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi

  sudo systemctl disable firewalld
  sudo pacman -R --noconfirm firewalld

  sudo pacman -R --noconfirm arc-gtk-theme-eos
  sudo pacman -Rdd --noconfirm endeavouros-skel-default endeavouros-skel-xfce4
  sudo pacman -R --noconfirm modemmanager
  sudo pacman -R --noconfirm yay

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi

# when on ALCI - remove conflicting files

if [ -f /usr/local/bin/get-nemesis-on-alci ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Removing software for ALCI"
  echo "################################################################"
  tput sgr0

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi
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
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi


# when on Garuda - remove conflicting files

if grep -q "Garuda" /etc/os-release; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Removing software for EOS"
  echo "################################################################"
  tput sgr0

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi

  sudo pacman -R --noconfirm blueman
  sudo pacman -R --noconfirm garuda-xfce-settings
  sudo pacman -R --noconfirm garuda-common-settings
  sudo pacman -R --noconfirm garuda-bash-config
  sudo pacman -R --noconfirm redshift
  sudo pacman -R --noconfirm hblock

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi


# when on SIERRA - remove conflicting files

if [ -f /usr/bin/get-nemesis-on-sierra ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "############### Removing software for Sierra"
  echo "################################################################"
  tput sgr0

  if [ -f /etc/skel/.bashrc ]; then
    sudo rm /etc/skel/.bashrc
  fi
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
  echo "################################################################"
  echo "################### Software removed"
  echo "################################################################"
  tput sgr0
  echo

fi

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo