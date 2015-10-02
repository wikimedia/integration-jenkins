#!/usr/bin/env python


# npm-install-dev.py
# ------------------
#
# Installs the development dependencies for Node.JS services. To use it,
# simply start it in the directory where your package.json file is
# located. Note that it assumes the production node module dependencies
# have already been installed, i.e. it does not check they are present.


import json
import subprocess


deps = dict()

print('[*] NPM devDependencies Installation [*]')

with open('./package.json') as fd:
    pkg_info = json.load(fd)
    if 'devDependencies' in pkg_info:
        deps = pkg_info['devDependencies']

for pkg in iter(deps):
    print('Installing', pkg, '...')
    subprocess.check_output(['npm', 'install', pkg + '@' + deps[pkg]])

print('[*] NPM devDependencies Done [*]')
