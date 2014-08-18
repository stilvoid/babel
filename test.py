#!/usr/bin/env python

from babel import babel_parse

def fail(actual, expected):
    raise Exception("'{}' did not match '{}'".format(actual, expected))

def compare(actual, expected):
    if actual == expected:
        print(".", end="")

    else:
        fail(actual, expected)

# Flat
print("Testing babel.py with flat parsing")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh, flat=True)

compare(len(foo.keys()), 13)
compare(foo["fred"], "My name is Bertie.")
compare(foo["long_test"], "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line")
compare(foo["map/jeff"], "bridges")
compare(foo["map/kate"], "beckinsale")
compare(foo["array"], "Numbers")
compare(foo["array/0"], "first one")
compare(foo["array/1"], "second one")
compare(foo["array/3"], "third one")
compare(foo["array/4/left"], "fourth")
compare(foo["array/4/right"], "one")
compare(foo["indented"], "whatever")
compare(foo["unindent"], "1")
compare(foo["other"], "side\nthing")

print()
print("Success")
print()

# Not flat
print("Testing babel.py with hierarchical parsing")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh, flat=False)

compare(len(foo.keys()), 7)
compare(foo["fred"], "My name is Bertie.")
compare(foo["long_test"], "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line")
compare(len(foo["map"].keys()), 2)
compare(foo["map"]["jeff"], "bridges")
compare(foo["map"]["kate"], "beckinsale")
compare(len(foo["array"].keys()), 5)
compare(foo["array"]["-"], "Numbers")
compare(foo["array"]["0"], "first one")
compare(foo["array"]["1"], "second one")
compare(foo["array"]["3"], "third one")
compare(len(foo["array"]["4"].keys()), 2)
compare(foo["array"]["4"]["left"], "fourth")
compare(foo["array"]["4"]["right"], "one")
compare(foo["indented"], "whatever")
compare(foo["unindent"], "1")
compare(foo["other"], "side\nthing")

print()
print("Success")
