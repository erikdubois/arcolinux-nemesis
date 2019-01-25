#!/bin/bash
set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

package=ncmpcpp

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

    #mpd is the music player daemon
    #it will scan for music and server music to its clients
    #https://wiki.archlinux.org/index.php/Music_Player_Daemon

    sudo pacman -S mpd --noconfirm --needed
    sudo pacman -S mpc --noconfirm --needed

    # no double config allowed in here and in ~/.config
    sudo rm /etc/mpd.conf

    mkdir -p ~/.config/mpd

    cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf

    sed -i 's/#music_directory/music_directory/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/music/~\/Music/g' ~/.config/mpd/mpd.conf

    sed -i 's/#playlist_directory/playlist_directory/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/playlists/~\/.config\/mpd\/playlists/g' ~/.config/mpd/mpd.conf


    sed -i 's/#db_file/db_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/database/~\/.config\/mpd\/database/g' ~/.config/mpd/mpd.conf

    sed -i 's/#log_file/log_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/log/~\/.config\/mpd\/log/g' ~/.config/mpd/mpd.conf

    sed -i 's/#pid_file/pid_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/pid/~\/.config\/mpd\/pid/g' ~/.config/mpd/mpd.conf

    sed -i 's/#state_file/state_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/state/~\/.config\/mpd\/state/g' ~/.config/mpd/mpd.conf

    sed -i 's/#sticker_file/sticker_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/sticker/~\/.config\/mpd\/sticker/g' ~/.config/mpd/mpd.conf

    sed -i 's/#bind_to_address/bind_to_address/g' ~/.config/mpd/mpd.conf

    sed -i 's/#port/port/g' ~/.config/mpd/mpd.conf

    sed -i 's/#auto_update/auto_update/g' ~/.config/mpd/mpd.conf

    sed -i 's/#follow_inside_symlinks/follow_inside_symlinks/g' ~/.config/mpd/mpd.conf

    sed -i 's/~\/.mpd\/socket/~\/.config\/mpd\/socket/g' ~/.config/mpd/mpd.conf

    sed -i 's/#filesystem_charset/filesystem_charset/g' ~/.config/mpd/mpd.conf

    echo 'audio_output {
          type  "alsa"
          name  "mpd-alsa"
          mixer_type "software"
    }

    audio_output {
    type               "fifo"
    name               "toggle_visualizer"
    path               "/tmp/mpd.fifo"
    format             "44100:16:2"
    }' >> ~/.config/mpd/mpd.conf


    mkdir ~/.config/mpd/playlists

    systemctl --user enable mpd.service
    systemctl --user start mpd.service

    # more info @ https://wiki.archlinux.org/index.php/ncmpcpp

    sudo pacman -S ncmpcpp --noconfirm --needed

    mkdir ~/.ncmpcpp
    cp /usr/share/doc/ncmpcpp/config ~/.ncmpcpp/config

    sed -i 's/#mpd_host/mpd_host/g' ~/.ncmpcpp/config
    sed -i 's/#mpd_port/mpd_port/g' ~/.ncmpcpp/config
    sed -i 's/#mpd_music_dir = ~\/music/mpd_music_dir = ~\/Music/g' ~/.ncmpcpp/config


    cp /usr/share/doc/ncmpcpp/bindings ~/.ncmpcpp/bindings

fi
