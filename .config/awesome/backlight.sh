#!/usr/bin/sh

if [ $# -eq 0 ]; then
    printf "%.*f\n" 0 $(xbacklight -get) 
else
    xbacklight -set $1
fi
