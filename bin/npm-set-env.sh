#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

#
# Script to set up custom environement variables for 'npm test'.
#
# Must be run in the directory containing package.json.
# For jobs that manually 'cd' into such directory, don't run it too early!
#

# Set CHROME_BIN for projects using karma-chrome-launcher as our slaves
# have Chromium instead of Chrome.
# https://github.com/karma-runner/karma-chrome-launcher/pull/41
export CHROME_BIN=`which chromium-browser`
