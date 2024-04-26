#!/bin/sh

#xrdb merge ~/.Xresources 
#xbacklight -set 10 &
#xset r rate 200 50 &

function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}

#run "xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output None-1-1 --off"

#run "dex $HOME/.config/autostart/arcolinux-welcome-app.desktop"
#run "xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal"
#run "xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off"
#run xrandr --output eDP-1 --primary --mode 1368x768 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
#run xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#run xrandr --output DVI-I-0 --right-of HDMI-0 --auto
#run xrandr --output DVI-1 --right-of DVI-0 --auto
#run xrandr --output DVI-D-1 --right-of DVI-I-1 --auto
#run xrandr --output HDMI2 --right-of HDMI1 --auto
#autorandr horizontal
#run "autorandr horizontal"
run "nm-applet"
#run "pamac-tray"
#run "variety"
run "xfce4-power-manager"
run "blueberry-tray"
run "/usr/lib/xfce4/notifyd/xfce4-notifyd"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
#picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
#run "numlockx on"
#run "volumeicon"
run "pa-applet"
sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &
#run "nitrogen --restore"
#run "conky -c $HOME/.config/arco-chadwm/conky/system-overview"
#you can set wallpapers in themes as well
#feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &
#feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
#feh --bg-fill ~/.config/arco-chadwm/wallpaper/chadwm.jpg &
#feh --bg-fill ~/.config/arco-chadwm/wallpaper/chadwm1.png &
#feh --randomize --bg-fill /home/erik/Insync/Apps/Wallhaven/*

xautolock -time 10 -locker slock &

#nitrogen --set-zoom-fill --random /home/erik/Insync/Apps/Desktoppr/ --head=0
#nitrogen --set-zoom-fill --random /home/erik/Insync/Apps/Desktoppr/ --head=1

#wallpaper for other Arch based systems
#feh --bg-fill /usr/share/archlinux-tweak-tool/data/wallpaper/wallpaper.png &
#run applications from startup

#run "insync start"
#run "spotify"
#run "ckb-next -b"
#run "discord"
#run "telegram-desktop"
#run "dropbox"
#run "/usr/bin/octopi-notifier"

pall &
#pkill bar.sh
#~/.config/arco-chadwm/scripts/bar.sh &
while type dwm >/dev/null; do dwm && continue || break; done
