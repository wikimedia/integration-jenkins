#!/usr/bin/env python
"""
    Reads branch names retaining wmf ones and print an ascending sorted list

    Example:

    git branch -r --list '*/wmf/*wmf*'|mw-sort-wmf-branch.py

"""

import fileinput
import distutils.version
import re

RE_WMF_BRANCH = r'^[^\/]+/wmf/\d+\.\d+wmf\d+'

VERSIONS = []
for l in fileinput.input():
    match = re.match(RE_WMF_BRANCH, l)
    if match:
        VERSIONS.append(l.rstrip())


VERSIONS.sort(key=distutils.version.LooseVersion)
print "\n".join(VERSIONS)
