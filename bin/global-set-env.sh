#!/bin/bash -eu

# Don't use JOB_NAME since that is not unique when running concurrent builds (T91070).
# Don't use a path longer than 55 characters in total. Chromium needs 45 characters
# for its user-data directory and socket. 103 is the Unix maxlength for socket paths (T93330).
if [ -d "$HOME/tmpfs" ]; then
	# All slaves should have tmpfs mounted, use if available
	export TMPDIR="$HOME/tmpfs/jenkins-${EXECUTOR_NUMBER}"
else
	export TMPDIR="/tmp/jenkins-${EXECUTOR_NUMBER}"
fi

# Integration slaves have an Xvfb window with server number 94 reserved for
# local applications (e.g. Chrome/Firefox).
export DISPLAY=':94'
