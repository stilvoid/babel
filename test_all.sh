#!/bin/bash

systems=(bash python js)

for system in ${systems[@]}; do
    if sut=$system cucumber -t ~@wip -t ~@not_$system; then
        echo $system passed
    else
        echo $system failed
        exit 1
    fi
done
