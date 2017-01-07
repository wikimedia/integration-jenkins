#!/bin/bash -eu

# Don't use JOB_NAME since that is not unique when running concurrent builds (T91070).
# Don't use a path longer than 55 characters in total. Chromium needs 45 characters
# for its user-data directory and socket. 103 is the Unix maxlength for socket paths (T93330).
#
# Dependent scripts/builders that have issues related to tmpfs, or a non-root
# temporary filesystem, can set `SKIP_TMPFS` to keep keep the temporary
# directory under /tmp.

# About $HOME
# -----------
#
# jenkins-slave (on prod) uses /var/lib/jenkins-slave
#
# jenkins-deploy has its home set to /mnt/home/jenkins-deploy in LDAP but we
# are moving to /srv T146381 hence we need to translate /mnt to /srv which is
# done with some bash magic.
export TMPDIR_FS="${HOME/#\/mnt//srv}/tmpfs/jenkins-${EXECUTOR_NUMBER}"
export TMPDIR_REGULAR="/tmp/jenkins-${EXECUTOR_NUMBER}"
if [ -d "${HOME/#\/mnt//srv}/tmpfs" ] && [ -z "${SKIP_TMPFS:-}" ]; then
	# All slaves should have tmpfs mounted, use if available
	export TMPDIR="${TMPDIR_FS}"
else
	export TMPDIR="${TMPDIR_REGULAR}"
fi

# Integration slaves have an Xvfb window with server number 94 reserved for
# local applications (e.g. Chrome/Firefox).
export DISPLAY=':94'

# - For karma-chrome-launcher v0.1.7 and earlier:
#   Set CHROME_BIN override to chromium-browser because older versions of
#   karma-chrome-launcher only support Chrome, not Chromium.
#   Fixed in v0.1.8 per https://github.com/karma-runner/karma-chrome-launcher/pull/41
# - For karma-chrome-launcher v0.1.8-v1.0.1:
#   No override needed. It detects all known binary names of Google Chrome
#   and Chromium for at least the Ubuntu and Debian distros.
# - For karma-chrome-launcher v2.0.0 and later:
#   Chrome and Chromium are now considered separate browsers, with their own
#   CHROMIUM_BIN and CHROME_BIN overrides (although we don't need any since
#   our distros are supported).
#   Most projects will configure their test pipeline to use Chrome
#   for local development. Set CHROME_BIN 'chromium-browser' (Ubuntu slaves)
#   or 'chromium' (Nodepool jessie slaves) because we install Chromium
#   instead of Chrome, but they are cli-compatible.
export CHROME_BIN=`which chromium-browser || which chromium`

# Shut up composer xdebug warnings: <https://getcomposer.org/xdebug>
# They're not useful to us and are distractions in logs
export COMPOSER_DISABLE_XDEBUG_WARN=1
