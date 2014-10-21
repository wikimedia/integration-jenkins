#!/bin/bash -ex

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

# We sometime have a tmpfs to use, that speeds up sqlite
if [ -d "$HOME/tmpfs" ]; then
	# We can not use JOB_NAME has a job identifier since when running in
	# parallel we will have a race condition. Instead use the trailing part of
	# the WORKSPACE which would be 'foo', 'foo@1', 'foo@2'
	# Trailing slash is important there.
	SQLITE_DIR="$HOME/tmpfs/`basename $WORKSPACE`"
else
	SQLITE_DIR="$WORKSPACE/data"
fi
mkdir -p $SQLITE_DIR

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"

# Purge sqlite databases modified more than 20 minutes ago
find "$SQLITE_DIR" -type f -name '*.sqlite' -mmin +20 -delete

# $wgDBName
DB_NAME="build${BUILD_NUMBER}"

# Run MediaWiki installer
cd "$MW_INSTALL_PATH"
php maintenance/install.php \
	--confpath "${MW_INSTALL_PATH}" \
	--dbtype=sqlite \
	--dbname="$DB_NAME" \
	--dbpath="$SQLITE_DIR" \
	--pass testpass \
	sqlitetest \
	WikiAdmin

# Installer creates sqlite db as 644 jenkins:jenkins
# Make the parent dir and the sqlite file writable by Apache (bug 47639)
chmod a+w "${SQLITE_DIR}"
chmod a+w "${SQLITE_DIR}/${DB_NAME}.sqlite"
