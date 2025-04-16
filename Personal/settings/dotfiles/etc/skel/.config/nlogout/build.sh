#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${!1}%s${NC}\n" "$2"
}


# Kill any running instances of nlogout
print_color "YELLOW" "Terminating any running nlogout instances..."
pkill -f "nlogout" || true  # Don't exit if no process found

# Install nim language
print_color "YELLOW" "Installing nim..."
if sudo pacman -S nim --noconfirm --needed; then
    print_color "GREEN" "nim installed successfully."
else
    print_color "RED" "Failed to install nim. Please install it manually and rerun this script."
    exit 1
fi

# Install required Nim modules
print_color "YELLOW" "Installing required Nim modules..."
if yes | nimble install parsetoml && yes | nimble install nigui; then
    print_color "GREEN" "Modules installed successfully."
else
    print_color "RED" "Failed to install required modules. Please check your internet connection and try again."
    exit 1
fi


# Compile nlogout
print_color "YELLOW" "Compiling nlogout..."
if nim compile --define:release --opt:size --app:gui --outdir="./bin" src/nlogout.nim; then
    sudo cp -v ./bin/nlogout /usr/bin/nlogout
    print_color "GREEN" "nlogout compiled successfully."
else
    print_color "RED" "Failed to compile nlogout. Please check the error messages above."
    exit 1
fi