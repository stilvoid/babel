#!/bin/bash

systems=($@)

if [ ${#systems[@]} -eq 0 ]; then
    systems=(bash python js)
fi

declare -A scores

for system in ${systems[@]}; do
    if sut=$system cucumber -t ~@wip -t ~@not_$system; then
        scores[$system]=passed
    else
        scores[$system]=failed
    fi
done

echo

for system in ${!scores[@]}; do
    echo $system: ${scores[$system]}
done
