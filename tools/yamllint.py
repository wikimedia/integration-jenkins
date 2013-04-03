#!/usr/bin/env python
#
#
# Copyright 2013, Antoine Musso
# Copyright 2013, Wikimedia Foundation Inc.
#
# Released under GPLv2
#
# Disable pylint checks about globals requiring upercase first:
# pylint: disable=C0103

"""A  basic script that recursively find YAML files under one or more
   directories and attempt to parse them using PyYAML.
"""
import argparse
import logging
import os
import sys
import yaml

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('-v', '-verbose', dest='verbose', action='count',
                    help='increase verbosity')
parser.add_argument('dirs', nargs='+',
                    help='paths to look for YAML files')
args = parser.parse_args()

# Set up verbosity
if args.verbose == 1:
    log_level = logging.INFO
elif args.verbose == 2:
    log_level = logging.DEBUG
else:
    log_level = logging.WARNING

logging.basicConfig(level=log_level, format='%(levelname)s %(message)s')

errors = 0
files = 0
for path in args.dirs:
    for root, dirnames, filenames in os.walk(path):
        for a_file in filenames:
            if a_file.lower().endswith(('.yaml', '.yml')):
                full_path = os.path.join(root, a_file)
                logging.debug("Invoking yaml.load on %s", full_path)
                try:
                    files += 1
                    yaml.load(file(full_path))
                    logging.info('[PASS] ' + full_path)
                except Exception, exc:
                    logging.error("Invalid file %s raised: %s",
                                  full_path, exc, exc_info=False)
                    errors += 1

if errors == 0:
    print "Good, all %s files passed!" % files
    sys.exit(0)
else:
    logging.error("Oh no, found %s files with errors out of %s files.",
                  errors, files)
    sys.exit(1)
