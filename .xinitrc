#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrandr --output DVI-I-1 --auto --right-of HDMI-0 --output HDMI-0 --auto

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.xterm ]] && xrdb -merge ~/.xterm

/usr/bin/xscreensaver -no-splash &

kbdd

setxkbmap -layout "us,ru" -option "grp:caps_toggle"

exec awesome
