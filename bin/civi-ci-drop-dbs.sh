#!/bin/bash

JOBID="${JOB_NAME// /_}_${BUILD_NUMBER}"

DRUPAL_SCHEMA="drupal_${JOBID}"
CIVICRM_SCHEMA="civicrm_${JOBID}"

echo "Dropping databases with the suffix -'_${JOBID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
EOS
