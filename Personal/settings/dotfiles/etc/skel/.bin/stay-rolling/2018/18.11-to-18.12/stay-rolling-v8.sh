#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "We uninstall first the files that are coming from the ArcoLinux iso,"
echo "then we install the same files from the ArcoLinux-system-config-git package."
echo "Essentially nothing has changed."
echo "But as from now we can manage these files with pacman and update them."

echo "First we update to get the new package in our database"

sudo pacman -Syy

sudo pacman -S arcolinux-bin-git --noconfirm

if [ -f /etc/modprobe.d/disable-evbug.conf ]; then
  sudo rm /etc/modprobe.d/disable-evbug.conf
fi

if [ -f /etc/modprobe.d/nobeep.conf ]; then
  sudo rm /etc/modprobe.d/nobeep.conf
fi

if [ -f /etc/modprobe.d/snd_pcsp.conf ]; then
  sudo rm /etc/modprobe.d/snd_pcsp.conf
fi

if [ -f /etc/sysctl.d/99-sysctl.conf ]; then
  sudo rm /etc/sysctl.d/99-sysctl.conf
fi

if [ -f /etc/udev/rules.d/60-ioschedulers.rules ]; then
  sudo rm /etc/udev/rules.d/60-ioschedulers.rules
fi

if [ -f /etc/X11/xorg.conf.d/99-killX.conf ]; then
  sudo rm /etc/X11/xorg.conf.d/99-killX.conf
fi

if [ -f /usr/share/applications/arcolinux-hello.desktop ]; then
  sudo rm /usr/share/applications/arcolinux-hello.desktop
fi

if [ -f /usr/share/icons/hicolor/256x256/apps/arco-calamares-logo.png ]; then
  sudo rm /usr/share/icons/hicolor/256x256/apps/arco-calamares-logo.png
fi

if [ -f /usr/share/icons/hicolor/256x256/apps/distributor-logo-arcolinux.svg ]; then
  sudo rm /usr/share/icons/hicolor/256x256/apps/distributor-logo-arcolinux.svg
fi

if [ -f /usr/bin/arcolinux-virtual-machine-check ]; then
  sudo rm /usr/bin/arcolinux-virtual-machine-check
fi

if [ -f /etc/systemd/system/reflector.service ]; then
  sudo rm /etc/systemd/system/reflector.service
fi

if [ -f /etc/systemd/system/reflector.timer ]; then
  sudo rm /etc/systemd/system/reflector.timer
fi

if [ -f /etc/systemd/system/virtual-machine-check.service ]; then
  sudo rm /etc/systemd/system/virtual-machine-check.service
fi

if [ -f /etc/samba/smb.conf.arcolinux ]; then
  sudo rm /etc/samba/smb.conf.arcolinux
fi

if [ -f /etc/samba/smb.conf.original ]; then
  sudo rm /etc/samba/smb.conf.original
fi

if [ -f /etc/sudoers.d ]; then
  sudo chmod 750 /etc/sudoers.d
fi

if [ -f /etc/polkit-1/rules.d ]; then
  sudo chmod 750 /etc/polkit-1/rules.d
fi

sudo chgrp polkitd /etc/polkit-1/rules.d


sudo pacman -S arcolinux-system-config-git --noconfirm


echo "################################################################"
echo "###                    All done                             ####"
echo "################################################################"
