#!/bin/sh

# Extract the correct Virtual output (either Virtual-1 or Virtual1)
VIRTUAL_OUTPUT=$(xrandr | grep -oP '^Virtual-?1(?=\sconnected)')

# If an output was found, apply xrandr settings
if [ -n "$VIRTUAL_OUTPUT" ]; then
    xrandr --output "$VIRTUAL_OUTPUT" --primary --mode 1920x1080 --pos 0x0 --rotate normal
fi

sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
variety -n &
numlockx on &
pkill bar.sh &
sh ~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
