#!/bin/bash -ex

# Adjust readlink for Mac OS X. You will need GNU utils
[ "`uname`" = "Darwin" ] && READLINK="greadlink" || READLINK="readlink"

# This script real full path
SCRIPT=$($READLINK -f "$0")
# This script real directory
SCRIPTPATH=$(dirname "$SCRIPT")
# Real path to MediaWiki extension loader
MW_EXT_LOADER=$($READLINK -f "$SCRIPTPATH/../tools/extensions-loader.php")

# We sometime have a tmpfs to use, that speeds up sqlite
if [ -d "$HOME/tmpfs" ]; then
	SQLITE_DIR="$HOME/tmpfs/$JOB_NAME"
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

# Enable debug log
MW_DEBUG_LOG_FILE="$WORKSPACE/mediawiki-debug.log"
touch "$MW_DEBUG_LOG_FILE"
# Should be writable by Apache as well
chmod 0666 "$MW_DEBUG_LOG_FILE"

echo "\$wgDebugLogFile = '$MW_DEBUG_LOG_FILE';
# Load extensions entry points
require_once( '$MW_EXT_LOADER' );
" >> "$WORKSPACE/LocalSettings.php"
