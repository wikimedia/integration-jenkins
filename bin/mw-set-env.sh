#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

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

export MW_TMPDIR="$TMPDIR"

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
