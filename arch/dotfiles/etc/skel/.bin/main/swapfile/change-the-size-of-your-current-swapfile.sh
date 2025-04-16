#!/bin/bash
#set -e
###############################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################

  if test -f /swapfile 
  then
  	tput setaf 2
  	echo "###############################################################################"
  	echo "Let us increase the current size of your /swapfile"
  	echo "###############################################################################"
  	tput sgr0
  else
  	tput setaf 2
  	echo "###############################################################################"
  	echo "This script is meant for users who have already a /swapfile and want"
  	echo "to increase the /swapfile"
  	echo "###############################################################################"
  	tput sgr0
  	exit 1
  fi

echo
echo "###############################################################################"
echo "CHOOSE THE SIZE OF YOUR SWAPFILE"
echo "EXPRESSED IN GB"
echo "CHOOSE A NUMBER BETWEEN 1 AND 32"
echo "###############################################################################"
echo
read choice

if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
	tput setaf 1
	echo "###############################################################################"
	echo "Only an integer number is allowed"
	echo "###############################################################################"
      	tput sgr0
    exit 1
fi


if [ "$choice" -ge 1 ] && [ "$choice" -le 32 ]

then
	echo
	echo "###############################################################################"
	echo "You have chosen "$choice" GB."
	echo "###############################################################################"

else 
	echo "###############################################################################"
	echo "Choose a number equal to or between 1-32"
	echo "###############################################################################"
	exit 1
fi
echo
echo "###############################################################################"
echo "Turning off current swapfile"
echo "###############################################################################"
sudo swapoff -a
echo
echo "###############################################################################"
echo "Making new swapfile - the bigger the number, the longer you have to wait"
echo "###############################################################################"
echo
sudo dd if=/dev/zero of=/swapfile bs=1G count=$choice status=progress
echo
echo "###############################################################################"
echo "Changing permissions on swapfile"
echo "###############################################################################"
sudo chmod 600 /swapfile
echo
echo "###############################################################################"
echo "Setting up Linux swapfile"
echo "###############################################################################"
echo
sudo mkswap /swapfile
echo
echo "###############################################################################"
echo "Activating swapfile"
echo "###############################################################################"
echo
sudo swapon /swapfile
echo
echo "###############################################################################"
echo "                  FINISHED - PLEASE REBOOT YOUR COMPUTER                       "
echo "###############################################################################"
echo


