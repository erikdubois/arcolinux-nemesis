#!/bin/bash
set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	Erik Dubois
# Website 	: 	http://www.erikdubois.be
##################################################################################################################
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "################################################################"
echo "#########        Creating folders               ################"
echo "################################################################"



[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"

[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

[ -d $HOME"/.gimp-2.8" ] || mkdir -p $HOME"/.gimp-2.8"
[ -d $HOME"/.gimp-2.8/scripts" ] || mkdir -p $HOME"/.gimp-2.8/scripts"
[ -d $HOME"/.gimp-2.8/themes" ] || mkdir -p $HOME"/.gimp-2.8/themes"

[ -d $HOME"/Desktop" ] || mkdir -p $HOME"/Desktop"
[ -d $HOME"/Documents" ] || mkdir -p $HOME"/Documents"
[ -d $HOME"/Downloads" ] || mkdir -p $HOME"/Downloads"
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"
[ -d $HOME"/ARCOLINUX" ] || mkdir -p $HOME"/ARCOLINUX"
#[ -d $HOME"/Dropbox" ] || mkdir -p $HOME"/Dropbox" will be created by dropbox
[ -d $HOME"/Insync" ] || mkdir -p $HOME"/Insync"
[ -d $HOME"/Music" ] || mkdir -p $HOME"/Music"
[ -d $HOME"/Pictures" ] || mkdir -p $HOME"/Pictures"
[ -d $HOME"/Videos" ] || mkdir -p $HOME"/Videos"


echo "################################################################"
echo "#########            folders created            ################"
echo "################################################################"
