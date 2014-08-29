#!/usr/bin/env python

import json
import sys

from babel import babel_parse

data = babel_parse(sys.stdin, flat="-noflat" not in sys.argv)

print(json.dumps(data))
