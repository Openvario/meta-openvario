#!/usr/bin/env python3
#
# Copyright 2022 Max Kellermann <max.kellermann@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# - Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# - Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the
# distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
# FOUNDATION OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

# This scripts convert an INI-like file to a C string literal.  This
# allows writing u-boot scripts more easily.

import sys

c_trans = str.maketrans({'\\': r'\\', '"': r'\"'})

def quote(s):
    global c_trans
    return s.translate(c_trans)

section = None

for line in sys.stdin:
    line = line.strip()
    if len(line) == 0 or line[0] == '#': continue

    if line[0] == '[':
        if line[-1] != ']':
            raise RuntimeError('Syntax error: ' + line)

        if section is not None:
            print('"\\0" \\')

        section = line[1:-1].strip()
        if len(section) == 0:
            raise RuntimeError('Syntax error: ' + line)
        print(f'"{section}=" \\')
    elif section is None:
        name, value = line.split('=', 1)
        if len(name) == 0:
            raise RuntimeError('Syntax error: ' + line)
        print(f'"{quote(line)}\\0" \\')
    else:
        print(f'  "{quote(line)} " \\')

if section is not None:
    print('"\\0" \\')
print('""')
