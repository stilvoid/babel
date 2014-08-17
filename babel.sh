#!/bin/bash

babel_help() {
    echo "Usage $0 [OPTION]"
    echo
    echo "  -g        Generate. Converts piped bash variable declarations into babel."
    echo "  -p        Parse. Converts piped babel into bash variable declarations."
    echo "  -h        Help. This text."
    echo
}

NAME_RE="[A-Za-z0-9_]+"

VAR_RE="^( *)($NAME_RE(\[$NAME_RE\])?)( *)=(.*)$"

babel_parse() {
    declare -A vars

    last_var=
    cont_re=

    output=

    while IFS= read -r line; do
        #echo "$line"

        if [[ "$line" =~ $VAR_RE ]]; then
            if [ -n "$last_var" ]; then
                output+="\"\n"
            fi

            last_var=${BASH_REMATCH[2]}
            ((indent_len=${#BASH_REMATCH[1]}+${#last_var}+${#BASH_REMATCH[4]}+1))
            value=${BASH_REMATCH[5]}

            output+="$last_var=\"$value"

            cont_re="^ {$indent_len}(.*)$"
        elif [[ "$line" =~ $cont_re ]]; then
            output+="\\\n${BASH_REMATCH[1]}"
        else
            echo "Invalid line: '$line'"
            exit 1
        fi
    done

    output+="\""

    echo -e $output
}

babel_generate() {
    echo Not yet implemented
    exit 1
}

if [[ ${BASH_SOURCE[0]} == $0 ]]; then
    command=$1

    case $command in
        -g) babel_generate ;;
        -p) babel_parse ;;
        -h) babel_help ;;
        *) babel_help ;;
    esac
fi
