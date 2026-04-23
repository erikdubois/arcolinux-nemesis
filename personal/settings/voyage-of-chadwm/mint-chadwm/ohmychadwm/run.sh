#!/bin/sh

# from nemesis

# Extract the correct Virtual output (either Virtual-1 or Virtual1)
VIRTUAL_OUTPUT=$(xrandr | grep -oP '^Virtual-?1(?=\sconnected)')

# If an output was found, apply xrandr settings
if [ -n "$VIRTUAL_OUTPUT" ]; then
    xrandr --output "$VIRTUAL_OUTPUT" --primary --mode 1920x1080 --pos 0x0 --rotate normal
fi

sxhkd -c ~/.config/ohmychadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
picom &
variety -n &
numlockx on &
while type ohmychadwm >/dev/null; do ohmychadwm && continue || break; done
