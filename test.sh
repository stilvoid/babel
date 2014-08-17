#!/bin/bash

. babel.sh

eval $(babel_parse <example.babel)

echo $indent
