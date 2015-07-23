#!/bin/bash -eu

# Xvfb barfs when trying to move xkb files across filesystems, so we must use
# /tmp for now
# https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/972324
export SKIP_TMPFS=1

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-localhost.sh

# Selenium requires the chromedriver binary to be found in our PATH
for path in /usr/lib/chromium-browser /usr/lib/chromium; do
	if test -d "$path"; then
		export PATH="$PATH:$path"
	fi
done

# Let MW-Selenium setup/teardown an isolated Xvfb on a display between 70-90
# for this build
export HEADLESS=true
export HEADLESS_DISPLAY=$((70 + EXECUTOR_NUMBER % 20))
export HEADLESS_DESTROY_AT_EXIT=true
export HEADLESS_CAPTURE_PATH="$WORKSPACE/log"

export MEDIAWIKI_ENVIRONMENT=integration
export MEDIAWIKI_URL="${MW_SERVER}${MW_SCRIPT_PATH}/index.php/"
export MEDIAWIKI_API_URL="${MW_SERVER}${MW_SCRIPT_PATH}/api.php"

export SCREENSHOT_FAILURES=true
export SCREENSHOT_FAILURES_PATH="$WORKSPACE/log"
