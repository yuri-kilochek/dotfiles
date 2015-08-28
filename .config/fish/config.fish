# start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

# keep prompt at bottom
function _keep_prompt_at_bottom --on-signal WINCH
    tput cup $LINES
end

