#!/bin/bash

. /srv/deployment/integration/slave-scripts/bin/civi-ci-settings.sh

echo "Creating databases with the suffix -'_${JOB_ID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
create database ${DRUPAL_SCHEMA};
create database ${CIVICRM_SCHEMA};

grant all on ${DRUPAL_SCHEMA}.* to ${CIVICRM_MYSQL_USERNAME}@${BUILD_HOST};
grant all on ${CIVICRM_SCHEMA}.* to ${CIVICRM_MYSQL_USERNAME}@${BUILD_HOST};
EOS
