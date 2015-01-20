#!/bin/bash -x
#
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

# We sometime have a tmpfs to use, that speeds up sqlite
if [ -d "$HOME/tmpfs" ]; then
	# We can not use JOB_NAME has a job identifier since when running in
	# parallel we will have a race condition. Instead use the trailing part of
	# the WORKSPACE which would be 'foo', 'foo@1', 'foo@2'
	# Trailing slash is important there.
	MW_DB_PATH="$HOME/tmpfs/`basename $WORKSPACE`"
else
	MW_DB_PATH="$WORKSPACE/data"
fi
export MW_DB_PATH

export MW_DB_NAME="build${BUILD_NUMBER}"

export LOG_DIR="$WORKSPACE/log"

# Create logs direcotry
# Make it writable by apache (for web requests such as from qunit tests)
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"
