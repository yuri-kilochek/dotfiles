disable_echo() {
    stty -echo
}

hide_cursor() {
    tput civis
}

move_top_left() {
    tput cup 0
}

shape_of() (
    lines=0
    columns=0
    while read -r line; do
        lines=$(expr $lines + 1)
        if [ ${#line} -gt $columns ]; then
            columns=${#line}
        fi
    done 
    printf '%d %d' $lines $columns
)

reshape() {
    printf $'\e[8;%d;%dt' $1 $2
}
