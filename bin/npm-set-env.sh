#!/bin/bash -eu

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
