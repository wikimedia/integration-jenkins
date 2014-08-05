#!/bin/bash

. /srv/deployment/integration/slave-scripts/bin/civi-ci-settings.sh

echo "Dropping databases with the suffix -'_${JOB_ID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};

REVOKE ALL PRIVILEGES, GRANT OPTION FROM ${CIVICRM_MYSQL_USERNAME}@${BUILD_HOST};
DROP USER ${CIVICRM_MYSQL_USERNAME}@${BUILD_HOST};
EOS
