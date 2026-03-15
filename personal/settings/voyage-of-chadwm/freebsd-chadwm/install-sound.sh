#!/bin/bash
# set -e
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

installed_dir=$(pwd)

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Installing sound"
echo "########################################################################"
tput sgr0
echo

sudo pkg install -y pulseaudio
sudo pkg install -y pavucontrol

# Define the configuration line
config_line='snd_driver_load="YES"'

# Check if the line is already present in /etc/rc.conf
if ! grep -qF "$config_line" /etc/rc.conf; then
  # If not present, append the line to /etc/rc.conf
  echo "$config_line" | sudo tee -a /etc/rc.conf
else
  echo "Configuration already present in /etc/rc.conf"
fi

# Define the configuration line
config_line='sound_load="YES"'

# Check if the line is already present in /etc/rc.conf
if ! grep -qF "$config_line" /etc/rc.conf; then
  # If not present, append the line to /etc/rc.conf
  echo "$config_line" | sudo tee -a /etc/rc.conf
else
  echo "Configuration already present in /etc/rc.conf"
fi

# Define the configuration line
config_line='snd_hda_load="YES"'

# Check if the line is already present in /etc/rc.conf
if ! grep -qF "$config_line" /etc/rc.conf; then
  # If not present, append the line to /etc/rc.conf
  echo "$config_line" | sudo tee -a /etc/rc.conf
else
  echo "Configuration already present in /etc/rc.conf"
fi

sudo pw groupmod pulse -m erik
sudo pw groupmod pulse-access -m erik

sudo service pulseaudio start

echo
tput setaf 6
echo "########################################################################"
echo "###### Installing sound ... done"
echo "########################################################################"
tput sgr0
echo
