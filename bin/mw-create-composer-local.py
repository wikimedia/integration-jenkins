#!/usr/bin/env python
from __future__ import print_function
"""
Creates a composer.local.json file for the
composer-merge-plugin to read based on a list
of provided extensions.

Usage: mw-create-composer-local.py extension_list.txt src/composer.local.json

"""

import json
import sys


def main(extlist_path, composerlocal_path):
    with open(extlist_path) as f:
        extensions = [ext.strip()[len('mediawiki/'):] + '/composer.json'
                      for ext in f.read().splitlines()
                      if ext.strip().startswith('mediawiki/extensions/')]

    out = {
        'extra': {
            'merge-plugin': {
                'include': extensions
            }
        }
    }

    with open(composerlocal_path, 'w') as f:
        json.dump(out, f)

    print('Created composer.local.json.')

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Invalid number of arguments provided')
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
