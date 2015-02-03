#!/bin/bash -x
#
# Script to set custom environement variables for 'npm test' jobs.
#
# Must be run in the directory containing package.json.
# For jobs that manually 'cd' into such directory, don't run it too early!
#

# Integration slaves have an Xvfb window with server number 94 reserved for
# local tests.
export DISPLAY=':94'

# Set CHROME_BIN for projects using karma-chrome-launcher as our slaves have
# Chromium instead of Chrome.
export CHROME_BIN=`which chromium-browser`

# Purge any existing node_modules. (T88395, T76304)
rm -rf node_modules
