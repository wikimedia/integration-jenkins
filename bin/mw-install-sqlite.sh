#!/bin/bash -ex

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

mkdir -p $MW_DB_PATH

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"

# Purge sqlite databases modified more than 20 minutes ago
find "$MW_DB_PATH" -type f -name '*.sqlite' -mmin +20 -delete

# Run MediaWiki installer
cd "$MW_INSTALL_PATH"
php maintenance/install.php \
	--confpath "${MW_INSTALL_PATH}" \
	--dbtype=sqlite \
	--dbname="$MW_DB_NAME" \
	--dbpath="$MW_DB_PATH" \
	--pass testpass \
	sqlitetest \
	WikiAdmin

# Installer creates sqlite db as 644 jenkins:jenkins
# Make the parent dir and the sqlite file writable by Apache (bug 47639)
chmod a+w "${MW_DB_PATH}"
chmod a+w "${MW_DB_PATH}/${MW_DB_NAME}.sqlite"
