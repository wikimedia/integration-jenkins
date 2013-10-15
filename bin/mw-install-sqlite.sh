#!/bin/bash -ex

# We sometime have a tmpfs to use, that speeds up sqlite
if [ -d "$HOME/tmpfs" ]; then
	# We can not use JOB_NAME has a job identifier since when running in
	# parallel we will have a race condition. Instead use the trailing part of
	# the WORKSPACE which would be 'foo', 'foo@1', 'foo@2'
	# Trailing slash is important there.
	SQLITE_DIR="$HOME/tmpfs/`basename $WORKSPACE`/"
	mkdir -p $SQLITE_DIR
else
	SQLITE_DIR="$WORKSPACE/data"
fi

# Ensure LocalSettings does not exist
rm -f LocalSettings.php
# Purge sqlite databases
rm -f "$SQLITE_DIR/*.sqlite"

# $wgDBName
DB_NAME="build${BUILD_NUMBER}"

# Run MediaWiki installer
php maintenance/install.php \
	--confpath "$WORKSPACE" \
	--dbtype=sqlite \
	--dbname="$DB_NAME" \
	--dbpath="$SQLITE_DIR" \
	--pass testpass \
	sqlitetest \
	WikiAdmin

# Installer creates sqlite db as 644 jenkins:jenkins
# Make it writable by Apache (bug 47639)
chmod a+w "${SQLITE_DIR}/${DB_NAME}.sqlite"
