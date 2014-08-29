#!/bin/bash

babel_help() {
    echo "Usage $0 [OPTION]"
    echo
    echo "  -g var         Generate. Converts piped bash variable declarations into babel."
    echo "  -p var <file>  Parse. Converts piped babel into bash variable declarations."
    echo "  -h             Help. This text."
    echo
}

NAME_RE="[[:alnum:]_]+"

VAR_RE="^( *)($NAME_RE(/$NAME_RE)*)( *)=(.*)$"

IGNORE_RE="(^[[:space:]]*$|^[[:space:]]*#)"

babel_parse() {
    if [ -z "$1" ]; then
        babel_help
        exit 1
    fi

    container=$1
    last_var=
    cont_re=
    output=
    file=${2:--}

    IFS=$'\n'

    local $container

    declare -A $container

    for line in $(cat $file); do
        if [[ "$line" =~ $VAR_RE ]]; then
            last_var=${BASH_REMATCH[2]}
            ((indent_len=${#BASH_REMATCH[1]}+${#last_var}+${#BASH_REMATCH[4]}))
            value=${BASH_REMATCH[5]}

            key_exists=$(eval "echo \${$container[$last_var]+isset}")

            if [ "$key_exists" ]; then
                eval "$container[$last_var]+=\"\n$value\""
            else
                eval "$container[$last_var]=\"$value\""
            fi

            cont_re="^ {$indent_len}[ =](.*)$"
        elif [[ -n "$last_var" && "$line" =~ $cont_re ]]; then
            eval "$container[$last_var]+=\"\n${BASH_REMATCH[1]}\""
        elif [[ ! "$line" =~ $IGNORE_RE ]]; then
            echo "Invalid line: '$line'"
            exit 1
        fi
    done

    declare -p $container
}

babel_generate() {
    output=

    if [ -z "$1" ]; then
        babel_help
        exit 1
    fi

    data=$(eval declare -p $1)

    eval "declare -A container=${data#*=}"

    for key in ${!container[@]}; do
        if [[ "${container[$key]}" =~ \\n ]]; then
            indent=$'\n'
            indent+="${key//?/ } "

            echo "$key=${container[$key]//\\n/$indent}"
        else
            echo $key=${container[$key]}
        fi
    done
}

if [[ ${BASH_SOURCE[0]} == $0 ]]; then
    command=$1
    shift

    case $command in
        -g) babel_generate $@ ;;
        -p) babel_parse $@ ;;
        -h) babel_help ;;
        *) babel_help ;;
    esac
fi
