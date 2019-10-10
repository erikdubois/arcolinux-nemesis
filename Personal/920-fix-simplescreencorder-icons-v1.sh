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

echo "making backups of older icons"

sudo mv /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder.png /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/16x16/apps/simplescreenrecorder-recording-backup.png


sudo mv /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder.png /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/22x22/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder.png /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/24x24/apps/simplescreenrecorder-recording-backup.png


sudo mv /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder.png /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/32x32/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder.png /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/48x48/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder.png /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/64x64/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder.png /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/96x96/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder.png /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/128x128/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder.png /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/192x192/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder.png /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-backup.png
sudo mv /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-error.png /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-error-backup.png
sudo mv /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-paused.png /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-paused-backup.png
sudo mv /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-recording.png /usr/share/icons/hicolor/256x256/apps/simplescreenrecorder-recording-backup.png

sudo mv /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder.svg /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-backup.svg
sudo mv /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-error.svg /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-error-backup.svg
sudo mv /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-paused.svg /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-paused-backup.svg
sudo mv /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-recording.svg /usr/share/icons/hicolor/scalable/apps/simplescreenrecorder-recording-backup.svg


installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

sudo cp $installed_dir/settings/simplescreenrecorder/png/* /usr/share/icons/hicolor/24x24/apps/
sudo cp $installed_dir/settings/simplescreenrecorder/svg/* /usr/share/icons/hicolor/scalable/apps/
