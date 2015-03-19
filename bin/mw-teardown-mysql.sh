#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-teardown.sh

mysql -u root <<EOS
DROP DATABASE IF EXISTS ${MW_DB};
EOS

mysql -u root <<EOS
REVOKE ALL PRIVILEGES, GRANT OPTION FROM '${MW_DB_USER}'@'${MW_DB_HOST}';
DROP USER '${MW_DB_USER}'@'${MW_DB_HOST}';
EOS
