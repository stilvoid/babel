#!/usr/bin/env python

from io import StringIO

from babel import babel_parse, babel_generate

def fail(actual, expected):
    raise Exception("'{}' did not match '{}'".format(actual, expected))

def compare(actual, expected):
    if actual == expected:
        print(".", end="")

    else:
        fail(actual, expected)

def test(input, flat=True, detect_lists=False):
    if flat and not detect_lists:
        compare(len(foo.keys()), 15)
        compare(foo["map/jeff"], "bridges")
        compare(foo["map/kate"], "beckinsale")
        compare(foo["array/0"], "first one")
        compare(foo["array/1"], "second one")
        compare(foo["array/2"], "third one")
        compare(foo["array/3"], "split")
        compare(foo["array/3/left"], "fourth")
        compare(foo["array/3/right"], "one")
        compare(foo["other_array/1"], "sparse")
        compare(foo["other_array/6"], "arrays")
    else:
        compare(len(foo.keys()), 8)
        compare(len(foo["map"].keys()), 2)
        compare(foo["map"]["jeff"], "bridges")
        compare(foo["map"]["kate"], "beckinsale")
        compare(len(foo["array"]), 4)
        compare(len(foo["other_array"].keys()), 2)
        compare(foo["other_array"]["1"], "sparse")
        compare(foo["other_array"]["6"], "arrays")

        if detect_lists:
            compare(foo["array"][0], "first one")
            compare(foo["array"][1], "second one")
            compare(foo["array"][2], "third one")
            compare(len(foo["array"][3].keys()), 3)
            compare(foo["array"][3]["-"], "split")
            compare(foo["array"][3]["left"], "fourth")
            compare(foo["array"][3]["right"], "one")
        else:
            compare(foo["array"]["0"], "first one")
            compare(foo["array"]["1"], "second one")
            compare(foo["array"]["2"], "third one")
            compare(len(foo["array"]["3"].keys()), 3)
            compare(foo["array"]["3"]["-"], "split")
            compare(foo["array"]["3"]["left"], "fourth")
            compare(foo["array"]["3"]["right"], "one")

    # Common
    compare(foo["fred"], "My name is Bertie.")
    compare(foo["long_test"], "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line")
    compare(foo["indented"], "whatever")
    compare(foo["unindent"], "1")
    compare(foo["other"], "side\nthing")


# Flat
print("Testing babel.py with flat parsing")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh, flat=True)
    test(foo, flat=True)

print()
print("Success")
print()


# Not flat
print("Testing babel.py with hierarchical parsing")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh, flat=False)
    test(foo, flat=False)

print()
print("Success")


# Detect lists
print("Testing babel.py with list detection")

with open("example.babel", "r") as fh:
    foo = babel_parse(fh, detect_lists=True)
    test(foo, detect_lists=True)

print()
print("Success")
print()


# Generate
print("Testing babel.py generation")

# Generate some babel from the last foo
babel = babel_generate(foo)

with StringIO("\n".join(babel)) as fh:
    foo = babel_parse(fh)
    test(foo)

print()
print("Success")
print()
