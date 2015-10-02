#!/usr/bin/python
# coding=utf-8
#
# Released under GPLv2
#
# Copyright © 2013 Andrew Bogott
# Copyright © 2013 Antoine Musso
# Copyright © 2013 Wikimedia Foundation Inc.
#
"""
Run the pep8 tool on each file in <path> and its subdirs.

This differs from the normal pep8 tool in that pep8 is invoked per file rather
than as one job; this means pep8 might load a different .pep8 rule for each
subdir.
"""

import argparse
import os
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('path', help='top level dir to begin pep8 tests')
args = parser.parse_args()

dir_tuples = os.walk(args.path)

success = True
for dir_tuple in dir_tuples:
    (dirpath, dirnames, filenames) = dir_tuple
    for f in filenames:
        if os.path.splitext(f)[1] != ".py":
            continue
        file_path = os.path.join(dirpath, f)

        # Craft a relative path to get shorter lines output
        rel_path = os.path.relpath(file_path, args.path)

        print("Checking file %s" % file_path)
        cmd = ('pep8', rel_path)

        # Invoke pep8 from the directory passed as an argument
        if subprocess.call(cmd, cwd=args.path):
            success = False

if success:
    print("\n\nAll tests passed.")
    exit(0)
else:
    print("\n\nSome tests failed. Review pep8 output above.")
    exit(1)
