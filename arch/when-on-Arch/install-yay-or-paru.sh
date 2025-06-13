#!/bin/bash

# URLs
yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay-git.tar.gz"
paru_url="https://aur.archlinux.org/cgit/aur.git/snapshot/paru-git.tar.gz"

# Prerequisites
for cmd in curl makepkg tar; do
  command -v "$cmd" >/dev/null || { echo "$cmd not found. Aborting."; exit 1; }
done

# Function to install a package from a URL
install_from_aur() {
  local url=$1
  local pkg_dir=$2

  workdir=$(mktemp -d)
  cd "$workdir" || exit 1

  echo "Downloading $pkg_dir..."
  curl -LO "$url" || { echo "Download failed"; return 1; }

  echo "Extracting $pkg_dir..."
  tar -xf "${pkg_dir}.tar.gz" || { echo "Extraction failed"; return 1; }

  cd "$pkg_dir" || return 1
  echo "Building and installing $pkg_dir..."
  makepkg -si
}

# Menu
echo "Choose a package to build:"
echo "1) yay-git"
echo "2) paru-git"
echo "3) both yay-git and paru-git"
echo "*) exit"
read -rp "Enter your choice: " choice

case $choice in
  1)
    install_from_aur "$yay_url" "yay-git"
    ;;
  2)
    install_from_aur "$paru_url" "paru-git"
    ;;
  3)
    install_from_aur "$yay_url" "yay-git"
    install_from_aur "$paru_url" "paru-git"
    ;;
  *)
    echo "Exiting."
    exit 0
    ;;
esac

