#!/bin/bash

# MYSQL database name cant use spaces or dashes:
JOB_ID="${JOB_NAME// /_}_${BUILD_NUMBER}"
JOB_ID="${JOB_ID//-/_}"

DRUPAL_SCHEMA="drupal_${JOB_ID}"
CIVICRM_SCHEMA="civicrm_${JOB_ID}"

echo "Dropping databases with the suffix -'_${JOB_ID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
EOS
