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

# https://wiki.archlinux.org/title/Limine

sudo pacman -S --noconfirm limine

# Define the content of the limine.cfg file
limine_cfg_content = """
:linux
KERNEL_PATH=/vmlinuz-linux
INITRD_PATH=/initramfs-linux.img
"""

# Specify the actual path where the limine.cfg file will be created, such as '/boot/limine.cfg'
limine_cfg_path = '/boot/efi/limine.cfg'

# Use Python to write the configuration content to the file
with open(limine_cfg_path, 'w') as limine_cfg_file:
    limine_cfg_file.write(limine_cfg_content)

print(f"Limine configuration file has been created at: {limine_cfg_path}")

sudo limine-bios-install /dev/sda 1

echo "############################################################################################################"
echo "#####################                             DONE                                 #####################"
echo "############################################################################################################"
