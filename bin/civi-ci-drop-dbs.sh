#!/bin/bash

. /srv/deployment/integration/slave-scripts/bin/civi-ci-settings.sh

echo "Dropping databases with the suffix -'_${JOB_ID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
EOS
