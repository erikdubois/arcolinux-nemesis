#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website : https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


echo "copy/pasting better toolbar icons over the original ones"


# these are for the icon in the taskbar

echo "making backups of older icons"

sudo mv /usr/share/icons/hicolor/16x16/apps/sublime-text.png /usr/share/icons/hicolor/16x16/apps/sublime-text.backup.png

sudo mv /usr/share/icons/hicolor/32x32/apps/sublime-text.png /usr/share/icons/hicolor/32x32/apps/sublime-text.backup.png

sudo mv /usr/share/icons/hicolor/48x48/apps/sublime-text.png /usr/share/icons/hicolor/48x48/apps/sublime-text.backup.png

sudo mv /usr/share/icons/hicolor/128x128/apps/sublime-text.png /usr/share/icons/hicolor/128x128/apps/sublime-text.backup.png

sudo mv /usr/share/icons/hicolor/256x256/apps/sublime-text.png /usr/share/icons/hicolor/256x256/apps/sublime-text.backup.png

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

sudo cp $installed_dir/settings/sublimetext/png/16x16/* /usr/share/icons/hicolor/16x16/apps/
sudo cp $installed_dir/settings/sublimetext/png/32x32/* /usr/share/icons/hicolor/32x32/apps/
sudo cp $installed_dir/settings/sublimetext/png/48x48/* /usr/share/icons/hicolor/48x48/apps/
sudo cp $installed_dir/settings/sublimetext/png/128x128/* /usr/share/icons/hicolor/128x128/apps/
sudo cp $installed_dir/settings/sublimetext/png/256x256/* /usr/share/icons/hicolor/256x256/apps/



# these are for the icon in the plank


sudo mv /opt/sublime_text_3/Icon/16x16/sublime-text.png /opt/sublime_text_3/Icon/16x16/sublime-text.backup.png

sudo mv /opt/sublime_text_3/Icon/32x32/sublime-text.png /opt/sublime_text_3/Icon/32x32/sublime-text.backup.png

sudo mv /opt/sublime_text_3/Icon/48x48/sublime-text.png /opt/sublime_text_3/Icon/48x48/sublime-text.backup.png

sudo mv /opt/sublime_text_3/Icon/128x128/sublime-text.png /opt/sublime_text_3/Icon/128x128/sublime-text.backup.png

sudo mv /opt/sublime_text_3/Icon/256x256/sublime-text.png /opt/sublime_text_3/Icon/256x256/sublime-text.backup.png


sudo cp $installed_dir/settings/sublimetext/png/16x16/* /opt/sublime_text_3/Icon/16x16/
sudo cp $installed_dir/settings/sublimetext/png/32x32/* /opt/sublime_text_3/Icon/32x32/
sudo cp $installed_dir/settings/sublimetext/png/48x48/* /opt/sublime_text_3/Icon/48x48/
sudo cp $installed_dir/settings/sublimetext/png/128x128/* /opt/sublime_text_3/Icon/128x128/
sudo cp $installed_dir/settings/sublimetext/png/256x256/* /opt/sublime_text_3/Icon/256x256/




echo "All images have been backupped and copy/pasted."
