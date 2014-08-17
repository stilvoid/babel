#!/usr/bin/env python

"""
Babel parser/generator
"""

import re
import sys

NAME_RE=r"\w+"
VAR_RE=r"^(?P<ws1> *)(?P<name>{}(?:\[{}\])?)(?P<ws2> *)=(?P<value>.*)$".format(NAME_RE, NAME_RE)
IGNORE_RE=r"(?:^\s*$|^\s*#)"

def babel_parse(fh):
    """
    Given a file handle, parses the babel contents and returns a dict
    """

    output = {}
    last_var = None
    cont_re = None

    for line in fh:
        var_match = re.match(VAR_RE, line)

        if cont_re:
            cont_match = re.match(cont_re, line)

        if var_match:
            cont_re = "^ {{{}}}(?P<value>.*)$".format(
                len(var_match.group("ws1"))
                +
                len(var_match.group("name"))
                +
                len(var_match.group("ws2"))
                + 1
            )

            output[var_match.group("name")] = var_match.group("value")

            last_var = var_match.group("name")

        elif last_var is not None and cont_match:
            output[last_var] += "\n{}".format(cont_match.group("value"))

        elif not re.match(IGNORE_RE, line):
            raise Exception("Invalid line: '{}'".format(line))

    return output

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        fh = open(sys.argv[1], "r")
    else:
        fh = sys.stdin

    print(babel_parse(fh))

    fh.close()
