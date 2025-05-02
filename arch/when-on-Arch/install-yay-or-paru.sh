#!/bin/bash

# URLs
yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay-git.tar.gz"
paru_url="https://aur.archlinux.org/cgit/aur.git/snapshot/paru-git.tar.gz"

# Menu
echo "Choose a package to build:"
echo "1) yay"
echo "2) paru"
echo "*) exit"
read -rp "Enter your choice: " choice

case $choice in
  1)
    cd /tmp || exit 1
    curl -LO "$yay_url"
    tar -xf yay-git.tar.gz
    cd yay-git || exit 1
    makepkg -si
    ;;
  2)
    cd /tmp || exit 1
    curl -LO "$paru_url"
    tar -xf paru-git.tar.gz
    cd paru-git || exit 1
    makepkg -si
    ;;
  *)
    echo "Exiting."
    exit 0
    ;;
esac
