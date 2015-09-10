disable_echo() {
    stty -echo
}

hide_cursor() {
    tput civis
}

move_top_left() {
    tput cup 0 0
}

get_shape() (
    lines=0
    columns=0
    IFS=''
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

read_key() (
    IFS=''
    read -rsn1 key
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k" 
    echo "$key"
)

bar() (
    width="$1"
    value="$2"
    state="$3"
    percent=$(printf '%.0f%%' "$(echo "$value * 100" | bc -l)")
    if [ "$state" = 'o' ]; then
        segment='#'
    elif [ "$state" = 'x' ]; then
        segment='='
    fi
    progress=$(printf '%.0f' "$(echo "$value * $width" | bc -l)")
    printf '%4s [' "$percent" 
    for _ in $(seq "$progress"); do
        printf "$segment"
    done
    for _ in $(seq "$(expr "$width" "-" "$progress")"); do
        printf ' '
    done
    printf ']'
)
