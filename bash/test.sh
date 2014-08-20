#!/bin/bash

. $(dirname $0)/babel.sh

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

test_parse() {
    foo=""
    eval $(babel_parse foo)

    compare "${#foo[@]}" "15"
    compare "${foo["fred"]}" "My name is Bertie."
    compare "${foo["long_test"]}" "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line"
    compare "${foo["map/jeff"]}" "bridges"
    compare "${foo["map/kate"]}" "beckinsale"
    compare "${foo["array/0"]}" "first one"
    compare "${foo["array/1"]}" "second one"
    compare "${foo["array/2"]}" "third one"
    compare "${foo["array/3"]}" "split"
    compare "${foo["array/3/left"]}" "fourth"
    compare "${foo["array/3/right"]}" "one"
    compare "${foo["other_array/1"]}" "sparse"
    compare "${foo["other_array/6"]}" "arrays"
    compare "${foo["indented"]}" "whatever"
    compare "${foo["unindent"]}" "1"
    compare "${foo["other"]}" "side\nthing"
}

echo "Testing babel parsing"

test_parse <example.babel

echo
echo "Success"
echo

echo "Testing babel generation"

# Re-parse the example file
eval $(babel_parse bar <example.babel)
# Generate babel from it
babel=$(babel_generate bar)
# And check that the generated babel parses
test_parse <<<"$babel"

echo
echo "Success"
echo
