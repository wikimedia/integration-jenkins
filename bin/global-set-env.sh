#!/bin/bash -eu

# Don't use JOB_NAME since that is not unique when running concurrent builds (T91070).
# Don't use a path longer than 55 characters in total. Chromium needs 45 characters
# for its user-data directory and socket. 103 is the Unix maxlength for socket paths (T93330).
#
# Dependent scripts/builders that have issues related to tmpfs, or a non-root
# temporary filesystem, can set `SKIP_TMPFS` to keep keep the temporary
# directory under /tmp.
if [ -d "$HOME/tmpfs" ] && [ "${SKIP_TMPFS:-0}" != "0" ]; then
	# All slaves should have tmpfs mounted, use if available
	export TMPDIR="$HOME/tmpfs/jenkins-${EXECUTOR_NUMBER}"
else
	export TMPDIR="/tmp/jenkins-${EXECUTOR_NUMBER}"
fi

# Integration slaves have an Xvfb window with server number 94 reserved for
# local applications (e.g. Chrome/Firefox).
export DISPLAY=':94'

# Set CHROME_BIN for projects using karma-chrome-launcher as our slaves
# have Chromium instead of Chrome.
# https://github.com/karma-runner/karma-chrome-launcher/pull/41
export CHROME_BIN=`which chromium-browser`
