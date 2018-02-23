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

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.xterm ]] && xrdb -merge ~/.xterm

export LANG=en_US.UTF-8

xscreensaver -no-splash &

compton -bCG

setxkbmap -layout "us,ru" -option "grp:caps_toggle"

exec awesome
