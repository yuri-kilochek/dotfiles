#!/bin/sh

sysresources=/etc/X11/xinit/.Xresources
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

sysmodmap=/etc/X11/xinit/.Xmodmap
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

usermodmap=$HOME/.Xmodmap
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xrdb -merge $HOME/.config/xtermrc

setxkbmap -model pc105 -layout us,ru -option grp:caps_toggle,grp_led:caps

numlockx &

xscreensaver -no-splash &
xss-lock -- xscreensaver-command --lock &

compton -b

exec awesome
