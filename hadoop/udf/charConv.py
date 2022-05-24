#!/usr/bin/env python
# charsetConversion.py

import struct

@outputSchema("word:chararray")
def toUTF8(s):
        line = ''.join([struct.pack('B', x).decode('windows-1250') for x in s])
        return line
