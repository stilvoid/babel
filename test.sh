#!/bin/bash

fail() {
    echo "'$1' did not match '$2'"
    exit 1
}

compare() {
    IFS=$'\n'

    if [ "$1" == "$2" ]; then
        echo -n .
    else
        fail $1 $2
    fi
}

echo "Testing babel.sh"

. babel.sh

eval $(babel_parse foo example.babel)

compare "${#foo[@]}" "10"
compare "${foo["fred"]}" "My name is Bertie."
compare "${foo["long_test"]}" "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line"
compare "${foo["map[jeff]"]}" "bridges"
compare "${foo["map[kate]"]}" "beckinsale"
compare "${foo["array[0]"]}" "first one"
compare "${foo["array[1]"]}" "second one"
compare "${foo["array[3]"]}" "third one"
compare "${foo["indented"]}" "whatever"
compare "${foo["unindent"]}" "1"
compare "${foo["other"]}" "side\nthing"

echo
echo "Success"
