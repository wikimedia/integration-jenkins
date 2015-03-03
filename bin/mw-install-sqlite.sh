#!/bin/bash -ex

. /srv/deployment/integration/slave-scripts/bin/mw-setup.sh

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"

# Run MediaWiki installer
cd "$MW_INSTALL_PATH"
php maintenance/install.php \
	--confpath "${MW_INSTALL_PATH}" \
	--dbtype=sqlite \
	--dbname="my_wiki" \
	--dbpath="$MW_TMPDIR" \
	--pass testpass \
	sqlitetest \
	WikiAdmin

# Installer creates files as 644 jenkins:jenkins
# Make the parent dir and files writable by Apache (bug 47639)
# - my_wiki.sqlite
# - wikicache.sqlite, wikicache.sqlite-shm, wikicache.sqlite-wal (since I864272af0)
chmod 777 $MW_TMPDIR/*
