#!/bin/bash -ex

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

mkdir -p $MW_DB_PATH

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"

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
# Make the parent dir and the db files writable by Apache (bug 47639)
chmod 777 "${MW_DB_PATH}"
chmod 777 "${MW_DB_PATH}/${MW_DB_NAME}.sqlite"
# Match wikicache.sqlite, wikicache.sqlite-shm, wikicache.sqlite-wal (since I864272af0 in mediawiki/core)
chmod 777 "${MW_DB_PATH}/wikicache.*"
