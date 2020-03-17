# start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

if status --is-interactive
    function __drop_prompt
        for i in (seq 100)
            echo
        end
    end

    function clear --wraps=clear
        command clear
        __drop_prompt
    end

    __drop_prompt

    function fish_prompt
        set -l last_status $status
        
        echo
        echo '[' $USER@(hostname) ']' (prompt_pwd)
        echo '> '

        return $last_status
    end

    function __clear_statusline --on-event fish_preexec
        set -l last_status $status
        
        tput cuu1
        tput cuu1
        tput dl1
        tput cud1

        return $last_status
    end
end
