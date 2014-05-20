#!/usr/bin/env python
"""
    Reads branch names retaining wmf ones and print an ascending sorted list

    Example:

    git branch -r --list '*/wmf/*wmf*'|mw-sort-wmf-branch.py

"""

import fileinput
from distutils.version import LooseVersion
import re

RE_WMF_BRANCH = r'^[^\/]+/wmf/\d+\.\d+wmf\d+'

VERSIONS = []
for l in fileinput.input():
    match = re.match(RE_WMF_BRANCH, l)
    if match:
        VERSIONS.append(l.rstrip())


def version_compare(a, b):
    """Very lame version comparaison """
    if LooseVersion(a) > LooseVersion(b):
        return 1
    else:
        return -1

VERSIONS.sort(cmp=version_compare)
print "\n".join(VERSIONS)
