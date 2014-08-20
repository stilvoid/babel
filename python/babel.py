#!/usr/bin/env python

"""
Babel parser/generator
"""

import re
import sys

NAME_RE=r"\w+"
VAR_RE=r"^(?P<ws1> *)(?P<name>{}(?:/{})*)(?P<ws2> *)=(?P<value>.*)$".format(NAME_RE, NAME_RE)
IGNORE_RE=r"(?:^\s*$|^\s*#)"

def _babel_detect_lists(output_dict):
    """
    Detects sub-lists with numeric, sequential, zero-based keys
    and converts them into lists
    """

    try:
        keys = [int(key) for key in sorted(output_dict.keys())]
    except Exception:
        keys = None

    if not keys or keys != list(range(len(keys))):
        if isinstance(output_dict, dict):
            return {
                key: _babel_detect_lists(value)
                for key, value
                in output_dict.items()
            }

        return output_dict

    return [
        _babel_detect_lists(output_dict[key])
        for key
        in sorted(output_dict.keys())
    ]

def _babel_get_value(output_dict, name, flat=True):
    """
    Gets the value from the correct place in the dict
    following the flattening rules specified in babel_parse
    """

    if flat:
        return output_dict[name]
    else:
        temp_dict = output_dict

        for key in name.split("/"):
            temp_dict = temp_dict[key]

        return temp_dict

def _babel_set_value(output_dict, name, value, flat=True):
    """
    Sets the value in the correct place in the dict
    following the flattening rules specified in babel_parse
    """

    if flat:
        output_dict[name] = value
    else:
        temp_dict = output_dict

        keys = name.split("/")

        for key in keys[:-1]:
            if key not in temp_dict:
                temp_dict[key] = {}

            elif not isinstance(temp_dict[key], dict):
                old_value = temp_dict[key]
                temp_dict[key] = {"": old_value}

            temp_dict = temp_dict[key]

        temp_dict[keys[-1]] = value

def babel_parse(fh, flat=True, detect_lists=False):
    """
    Given a file handle, parses the babel contents and returns a dict
    If flat is true, keys will contain all parts of the identifier
    Otherwise, dicts will be created.

    E.g. `array/0=hello` will become `{"array/0": "hello"}` if flat is True
    `array/0=hello` will become `{"array": {"0": "hello"}}` if flat is False

    In the case where a value is ascribed to both
    the initial part of an identifier and a sub-section
    babel.py will use the special key "" which is an
    invalid babel identifier

    E.g.
        array=hello
        array/0=world
        array/1=kitty

    Will become:
        {
            "array": {
                "": "hello",
                "0": "world",
                "1": "kitty",
            }
        }

    If `detect_lists` is True, babel will convert
    dicts with sequential, zero-based, numeric keys into lists.

    E.g.
        array/0=one
        array/1=two
        array/2=three

    Will become:
        {
            "array": ["one", "two", "three"]
        }

    `detect_lists` implies `flat=False` for obvious reasons
    """

    if detect_lists:
        flat = False

    output = {}
    last_var = None
    cont_re = None

    for line in fh:
        var_match = re.match(VAR_RE, line)

        if cont_re:
            cont_match = re.match(cont_re, line)

        if var_match:
            cont_re = "^ {{{}}}[ =](?P<value>.*)$".format(
                len(var_match.group("ws1"))
                +
                len(var_match.group("name"))
                +
                len(var_match.group("ws2"))
            )

            _babel_set_value(
                output,
                var_match.group("name"),
                var_match.group("value"),
                flat=flat
            )

            last_var = var_match.group("name")

        elif last_var is not None and cont_match:
            _babel_set_value(
                output,
                last_var,
                _babel_get_value(output, last_var, flat=flat) + "\n{}".format(cont_match.group("value")),
                flat=flat
            )

        elif not re.match(IGNORE_RE, line):
            raise Exception("Invalid line: '{}'".format(line))

    if detect_lists:
        output = _babel_detect_lists(output)

    return output

def babel_generate(input_dict, prefix=""):
    """
    Given a dict, outputs a babel representation as a string
    """

    output = []

    for key, value in input_dict.items():
        if isinstance(value, dict):
            output += babel_generate(value, "{}{}/".format(prefix, key))
        elif isinstance(value, list):
            output += babel_generate({
                index: entry
                for index, entry
                in enumerate(value)
            }, "{}{}/".format(prefix, key))
        else:
            indent_len = len(prefix) + len(str(key)) + 1
            value = re.sub(r'\n', "\n{}".format(" " * indent_len), value)

            if key == "":
                output.append("{}={}".format(prefix[:-1], value))
            else:
                output.append("{}{}={}".format(prefix, key, value))

    return output

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        fh = open(sys.argv[1], "r")
    else:
        fh = sys.stdin

    print(babel_parse(fh))

    fh.close()
