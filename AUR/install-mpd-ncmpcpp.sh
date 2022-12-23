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


    #mpd is the music player daemon
    #it will scan for music and server music to its clients
    #https://wiki.archlinux.org/index.php/Music_Player_Daemon

    sudo pacman -S mpd --noconfirm --needed
    sudo pacman -S mpc --noconfirm --needed

    # no double config allowed in here and in ~/.config
    sudo rm /etc/mpd.conf

    mkdir -p ~/.config/mpd

    cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf

    #exit 1

    #music_directory    "~/music"

    sed -i '0,/#music_directory/s//music_directory/' ~/.config/mpd/mpd.conf
    sed -i 's/~\/music/~\/Music/g' ~/.config/mpd/mpd.conf

    #playlist_directory   "~/.mpd/playlists"

    sed -i 's/#playlist_directory/playlist_directory/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/playlists/~\/.config\/mpd\/playlists/g' ~/.config/mpd/mpd.conf

    #db_file      "~/.mpd/database"

    sed -i 's/#db_file/db_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/database/~\/.config\/mpd\/database/g' ~/.config/mpd/mpd.conf

    #log_file     "~/.mpd/log"

    sed -i 's/#log_file/log_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/log/~\/.config\/mpd\/log/g' ~/.config/mpd/mpd.conf

    #pid_file     "~/.mpd/pid"

    sed -i 's/#pid_file/pid_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/pid/~\/.config\/mpd\/pid/g' ~/.config/mpd/mpd.conf

    #state_file     "~/.mpd/state"

    sed -i 's/#state_file/state_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/state/~\/.config\/mpd\/state/g' ~/.config/mpd/mpd.conf

    #sticker_file     "~/.mpd/sticker.sql"

    sed -i 's/#sticker_file/sticker_file/g' ~/.config/mpd/mpd.conf
    sed -i 's/~\/.mpd\/sticker/~\/.config\/mpd\/sticker/g' ~/.config/mpd/mpd.conf

    #bind_to_address    "any"

    sed -i 's/#bind_to_address/bind_to_address/g' ~/.config/mpd/mpd.conf
    sed -i 's/"any"/"127.0.0.1"/g' ~/.config/mpd/mpd.conf


    #port       "6600"

    sed -i 's/#port/port/g' ~/.config/mpd/mpd.conf

    #auto_update  "yes"

    sed -i 's/#auto_update/auto_update/g' ~/.config/mpd/mpd.conf

    #follow_inside_symlinks   "yes"

    sed -i 's/#follow_inside_symlinks/follow_inside_symlinks/g' ~/.config/mpd/mpd.conf

    # socket
    
    sed -i 's/~\/.mpd\/socket/~\/.config\/mpd\/socket/g' ~/.config/mpd/mpd.conf

    #filesystem_charset   "UTF-8"

    sed -i 's/#filesystem_charset/filesystem_charset/g' ~/.config/mpd/mpd.conf

    echo 'audio_output {
          type  "pulse"
          name  "pulseaudio"
    }

    audio_output {
    type               "fifo"
    name               "Visualizer"
    path               "/tmp/mpd.fifo"
    format             "44100:16:2"
    }' >> ~/.config/mpd/mpd.conf


    mkdir ~/.config/mpd/playlists

    systemctl --user enable --now mpd.service


##############################################################################


    # more info @ https://wiki.archlinux.org/index.php/ncmpcpp

    sudo pacman -S ncmpcpp --noconfirm --needed

    mkdir -p ~/.config/ncmpcpp
    cp /usr/share/doc/ncmpcpp/config ~/.config/ncmpcpp/config

    #exit 1

    #ncmpcpp_directory = ~/.config/ncmpcpp

    sed -i 's/#ncmpcpp_directory/ncmpcpp_directory/g' ~/.config/ncmpcpp/config

    #lyrics_directory = ~/.lyrics

    sed -i 's/#lyrics_directory/lyrics_directory/g' ~/.config/ncmpcpp/config

    #mpd_host             = "localhost"

    sed -i 's/#mpd_host/mpd_host/g' ~/.config/ncmpcpp/config

    #mpd_port             = "6600"

    sed -i 's/#mpd_port/mpd_port/g' ~/.config/ncmpcpp/config

    #mpd_connection_timeout = 5

    sed -i 's/#mpd_connection_timeout/mpd_connection_timeout/g' ~/.config/ncmpcpp/config


    #mpd_music_dir = ~/music

    sed -i 's/#mpd_music_dir = ~\/music/mpd_music_dir = ~\/Music/g' ~/.config/ncmpcpp/config

    #mpd_crossfade_time = 5

    sed -i 's/#mpd_crossfade_time/mpd_crossfade_time/g' ~/.config/ncmpcpp/config


    cp /usr/share/doc/ncmpcpp/bindings ~/.config/ncmpcpp/bindings


