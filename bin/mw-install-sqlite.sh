#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-setup.sh

# Run MediaWiki installer
cd "$MW_INSTALL_PATH"
php maintenance/install.php \
	--confpath "$MW_INSTALL_PATH" \
	--dbtype=sqlite \
	--dbpath="$MW_TMPDIR" \
	--dbname="$MW_DB" \
	--pass testpass \
	TestWiki \
	WikiAdmin

# Installer creates files as 644 jenkins:jenkins
# Make the parent dir and files writable by Apache (bug 47639)
# - my_wiki.sqlite
# - wikicache.sqlite, wikicache.sqlite-shm, wikicache.sqlite-wal (since I864272af0)
chmod 777 $MW_TMPDIR/*
