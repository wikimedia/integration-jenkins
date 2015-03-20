#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-setup.sh

mysql -u root <<EOS
DROP DATABASE IF EXISTS ${MW_DB};
CREATE DATABASE ${MW_DB};
GRANT ALL ON ${MW_DB}.* to '${MW_DB_USER}'@'${MW_DB_HOST}' identified by '${MW_DB_PASS}';
EOS

# Run MediaWiki installer
cd "$MW_INSTALL_PATH"
php maintenance/install.php \
	--confpath "$MW_INSTALL_PATH" \
	--dbtype=mysql \
	--dbserver="$MW_DB_HOST" \
	--dbuser="$MW_DB_USER" \
	--dbpass="$MW_DB_PASS" \
	--dbname="$MW_DB" \
	--pass testpass \
	TestWiki \
	WikiAdmin
