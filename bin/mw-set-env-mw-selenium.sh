#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-localhost.sh

# Let MW-Selenium setup/teardown an isolated Xvfb on a display between 70-90
# for this build
export HEADLESS=true
export HEADLESS_DISPLAY=$((70 + EXECUTOR_NUMBER % 20))
export HEADLESS_DESTROY_AT_EXIT=true

# Xvfb barfs when trying to move xkb files across filesystems, so we must use
# /tmp for this job
# https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/972324
export TMPDIR="/tmp/jenkins-${EXECUTOR_NUMBER}"

export MEDIAWIKI_ENVIRONMENT=integration
export MEDIAWIKI_URL="${MW_SERVER}${MW_SCRIPT_PATH}/index.php/"
export MEDIAWIKI_API_URL="${MW_SERVER}${MW_SCRIPT_PATH}/api.php"

export SCREENSHOT_FAILURES=true
export SCREENSHOT_FAILURES_PATH="$WORKSPACE/log"
