disable_echo() {
    stty -echo
}

hide_cursor() {
    tput civis
}

get_shape() (
    if [ $# -eq 1 ]; then
        echo "$1" | get_shape
    else
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
    fi
)

reshape() {
    printf $'\e[8;%d;%dt' $1 $2
}

render() {
    reshape $(get_shape "$1")
    tput cup 0 0
    tput ed
    printf '%s' "$1"
}

read_key() (
    IFS=''
    if [ $# -eq 1 ]; then
        read -t "$1" -rsn1 key
    else
        read -rsn1 key
    fi
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k"
    read -t 0.0001 -rsn1 k && key="$key$k" 
    printf '%s' "$key"
)

bar() (
    width="$1"
    tokens="$2"
    percent="$3"
    part=$(printf '%.0f' "$(echo $percent / 100 '*' $width | bc -l)")
    for _ in $(seq "$part"); do
        printf '%s' "${tokens:0:1}"
    done
    for _ in $(seq "$(expr "$width" "-" "$part")"); do
        printf '%s' "${tokens:1:1}"
    done
)

trialign() (
    width=$1
    left=$2
    middle=$3
    right=$4
    gap=$(expr \( $width - ${#middle} \) / 2)
    if [ $(expr $gap '*' 2 + ${#middle}) -lt $width ]; then
        middle=" $middle"
    fi
    printf '%-*s%s%*s' $gap "$left" "$middle" $gap "$right"
)
