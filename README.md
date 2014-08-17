# Babel

An easy-to-parse and easy-to-produce data exchange format for easing communication between processes written in different programming languages.

## Principles

Everything must be named.

There are only 2 data types:

* Text

* Map

Any other data types can be converted within your programs as needed.

For example, you could represent the boolean values `true` and `false` with the words "true" and "false" or the numbers 0 and 1 (although they will be represented in babel as the strings "0" and "1").

Names can contain only letters (upper or lower case), and numbers. The same is true of indexes into maps.

## Examples

         fred=My name is fred.
    long_test=This is some long text.
              Lines breaks can be included by indenting
              level with the opening line
    map[jeff]=bridges
    map[kate]=beckinsale
     array[0]=first one
     array[1]=second one
     array[3]=third one

Indenting before the variable name is optional (though prettier)
