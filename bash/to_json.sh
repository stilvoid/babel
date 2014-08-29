#!/bin/bash

IFS=$'\n'

. $(dirname $0)/babel.sh

eval $(babel_parse bar)

((i=0))

echo {
for key in ${!bar[@]}; do
    echo -n "\"$key\": \"${bar["$key"]}\""

    ((i+=1))

    if [ $i -ne ${#bar[@]} ]; then
        echo ,
    else
        echo
    fi
done
echo }
