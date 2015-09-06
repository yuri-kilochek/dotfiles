disable_echo() {
    stty -echo
}

hide_cursor() {
    tput civis
}

move_top_left() {
    tput cup 0
}

get_shape() (
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

reshape_and_print() {
    reshape $(echo "$1" | get_shape)
    printf '%s' "$1"
}
