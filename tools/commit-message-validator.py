#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# License: GPLv2+
# Copyright (c) 2015 Bryan Davis and Wikimedia Foundation.
"""
Validate the format of a commit message to WMF Gerrit standards.

https://www.mediawiki.org/wiki/Gerrit/Commit_message_guidelines
"""

import re
import subprocess


def line_has_errors(lineno, line):
    """Check a commit message line to see if it has errors.

    Checks:
    - First line <=80 characters
    - Second line blank
    - No line >100 characters
    - "Bug:" is capitalized
    - "Bug:" is followed by a space
    - Exactly one task id on each Bug: line
    - No "Task: ", "Fixes: ", "Closes: " lines
    """
    rline = lineno + 1

    # First line <=80
    if lineno == 0 and len(line) > 80:
        return "Line %d: First line should be <=80 characters" % rline

    # Second line blank
    if lineno == 1 and line:
        return "Line %d: Second line should be empty" % rline

    # No line >100
    if len(line) > 100:
        return "Line %d: Line should be <=100 characters" % rline

    m = re.match(r'^(bug:)(.)', line, re.IGNORECASE)
    if m:
        if m.group(1) != 'Bug:':
            return "Line %d: Expected 'Bug:' not '%s'" % (rline, m.group(1))

        if m.group(2) != ' ':
            return "Line %d: Expected space after 'Bug:'" % rline

        # Exactly one task id on each Bug: line
        m = re.match(r'^Bug: \w+$', line)
        if not m:
            return "Line %d: Each Bug: should list exactly one task" % rline

    # No "Task: ", "Fixes: ", "Closes: " lines
    m = re.match(r'^(closes|fixes|task):', line, re.IGNORECASE)
    if m:
        return "Line %d: Use 'Bug: ' not '%s'" % (rline, m.group(0))

    return False


def check_message(lines):
    """Check a commit message to see if it has errors.

    Checks:
    - All lines ok as checked by line_has_errors()
    - For any "^Bug: " line, next line is not blank
    - For any "^Bug: " line, prior line is another Bug: line or empty
    - Exactly one "Change-Id: " line per commit
    - For "Change-Id: " line, prior line is empty or "^Bug: "
    - No blank lines between any "Bug: " lines and "Change-Id: "
    - Only "(cherry picked from commit" can follow "Change-Id: "
    - Message has at least 3 lines (subject, blank, Change-Id)
    """
    errors = []
    last_lineno = 0
    last_line = ''
    changeid_line = False
    last_bug = False
    for lineno, line in enumerate(lines):
        # Strip leading spaces to remove `git log` indenting
        stripped = line.lstrip()
        rline = lineno + 1
        e = line_has_errors(lineno, stripped)
        if e:
            errors.append(e)

        # For any "Bug: " line, next line is not blank
        if last_bug == last_lineno:
            if not line:
                errors.append(
                    "Line %d: Unexpected blank line after Bug:" % rline)

        # For any "Bug: " line, prior line is another Bug: line or empty
        if line.startswith('Bug: '):
            last_bug = rline
            if last_line and not last_line.startswith('Bug: '):
                errors.append(
                    "Line %d: Expected blank line before Bug:" % rline)

        if line.startswith('Change-Id: I'):
            # Only expect one "Change-Id: " line
            if changeid_line is not False:
                errors.append(
                    "Line %d: Extra Change-Id found, next at %d" %
                    (changeid_line, rline))

            # For "Change-Id: " line, prior line is empty or Bug:
            elif last_line and not last_line.startswith('Bug: '):
                errors.append(
                    "Line %d: Expected blank line or Bug: before Change-Id:" %
                    rline)

            # If we have Bug: lines, Change-Id follows immediately
            elif last_bug and last_bug != rline - 1:
                for lno in range(last_bug + 1, rline):
                    errors.append(
                        "Line %d: Unexpected line between Bug: and Change-Id:"
                        % lno)

            changeid_line = rline

        last_lineno = rline
        last_line = stripped

    if last_lineno < 2:
        errors.append("Line %d: Expected at least 3 lines" % last_lineno)

    if changeid_line is False:
        errors.append("Line %d: Expected Change-Id" % last_lineno)

    elif changeid_line != last_lineno:
        if last_lineno != changeid_line + 1:
            for lno in range(changeid_line + 1, last_lineno):
                errors.append(
                    "Line %d: Unexpected line after Change-Id" % lno)
        if not last_line.startswith("(cherry picked from commit"):
            errors.append(
                "Line %d: Unexpected line after Change-Id" % last_lineno)

    if errors:
        for e in errors:
            print e
        return 1
    return 0


def main():
    """Validate the current HEAD commit message."""
    commit = subprocess.check_output('git log --pretty=raw -1', shell=True)
    lines = commit.splitlines()

    # Discard until the first blank line
    line = lines.pop(0)
    while line:
        line = lines.pop(0)

    return check_message(lines)

if __name__ == '__main__':
    import sys
    sys.exit(main())
