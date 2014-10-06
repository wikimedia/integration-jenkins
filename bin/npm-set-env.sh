#!/bin/bash -x
#
# Script to set custom environement variables for 'npm test' jobs.
#

# Integration slaves have an Xvfb window with server number 94 reserved for
# local tests.
export DISPLAY=':94'

# Set CHROME_BIN for projects using karma-chrome-launcher as our slaves have
# Chromium instead of Chrome.
export CHROME_BIN=`which chromium-browser`
