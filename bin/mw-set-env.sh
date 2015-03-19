#!/bin/bash -ux

# Script to set up various environement variables suitable to test out
# MediaWiki core and extensions on Wikimedia continuous integration platform.

# allow the dumping of corefiles, up to 2GB
ulimit -c 2097152

MW_INSTALL_PATH=$WORKSPACE
for mw_path in src/mediawiki/core src; do
	if [[ -d "$WORKSPACE/$mw_path" ]]; then
		MW_INSTALL_PATH="$WORKSPACE/$mw_path"
		break
	fi;
done;
export MW_INSTALL_PATH

# All slaves should have tmpfs mounted, use if available
if [ -d "$HOME/tmpfs" ]; then
	# Don't use JOB_NAME since that is not unique when running concurrent builds (T91070).
	export TMPDIR="$HOME/tmpfs/$BUILD_TAG"
	export MW_TMPDIR="$TMPDIR"
else
	export MW_TMPDIR="$WORKSPACE/data"
fi

# Predicitable database credentials
# MySQL dbname maxlength: 62 (no spaces or dashes)
# Note: Use EXECUTOR_NUMBER instead BUILD_TAG as the latter risks being too long.
# https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project
export MW_DB="jenkins_u${EXECUTOR_NUMBER}_mw"
export MW_DB_HOST="localhost"
# MySQL username maxlength: 16
export MW_DB_USER="jenkins_u${EXECUTOR_NUMBER}"
export MW_DB_PASS="pw_jenkins_u${EXECUTOR_NUMBER}"

export LOG_DIR="$WORKSPACE/log"

# Create logs direcotry
# Make it writable by apache (for web requests such as from qunit tests)
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"
