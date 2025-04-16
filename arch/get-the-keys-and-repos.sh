#!/bin/bash

######################################################################################################################
sudo pacman -Sy
sudo pacman -S wget --noconfirm --needed
sudo pacman -S jq --noconfirm --needed
arco_repo_db=$(wget -qO- https://api.github.com/repos/arcolinux/arcolinux_repo/contents/x86_64)
echo "Getting the ArcoLinux keys from the ArcoLinux repo"

sudo wget "$(echo "$arco_repo_db" | jq -r '[.[] | select(.name | contains("arcolinux-keyring")) | .name] | .[0] | sub("arcolinux-keyring-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-")')" -O /tmp/arcolinux-keyring-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-git-any.pkg.tar.zst

######################################################################################################################

echo "Getting the latest arcolinux mirrors file"

sudo wget "$(echo "$arco_repo_db" | jq -r '[.[] | select(.name | contains("arcolinux-mirrorlist-git-")) | .name] | .[0] | sub("arcolinux-mirrorlist-git-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-")')" -O /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst

if grep -q 'arcolinux_repo' /etc/pacman.conf && \
   grep -q 'arcolinux_repo_3party' /etc/pacman.conf; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################ ArcoLinux repos are already in /etc/pacman.conf "
  echo "################################################################"
  tput sgr0
  echo

else
  sudo cp /etc/pacman.conf /etc/pacman.conf.nemesis
  sudo cp ../etc/pacman.conf /etc/pacman.conf
fi