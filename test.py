#!/usr/bin/env python

from babel import babel_parse

def fail(actual, expected):
    raise Exception("'{}' did not match '{}'".format(actual, expected))

def compare(actual, expected):
    if actual == expected:
        print(".", end="")

    else:
        fail(actual, expected)

print("Testing babel.sh")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh)

compare(len(foo.keys()), 10)
compare(foo["fred"], "My name is Bertie.")
compare(foo["long_test"], "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line")
compare(foo["map[jeff]"], "bridges")
compare(foo["map[kate]"], "beckinsale")
compare(foo["array[0]"], "first one")
compare(foo["array[1]"], "second one")
compare(foo["array[3]"], "third one")
compare(foo["indented"], "whatever")
compare(foo["unindent"], "1")
compare(foo["other"], "side\nthing")

print()
print("Success")
