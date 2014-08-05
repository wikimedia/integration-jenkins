#!/bin/bash

if [ "x${JOB_NAME}" = "x" ]; then
	echo "JOB_NAME environment variable was not set, exiting."
	exit 1
fi
if [ "x${BUILD_NUMBER}" = "x" ]; then
	echo "BUILD_NUMBER environment variable was not set, exiting."
	exit 1
fi

JOBID="${JOB_NAME// /_}_${BUILD_NUMBER}"

BUILD_HOST=`hostname`
USERNAME="civitest_${JOBID}"
PASSWORD="pw_${JOBID}"
DRUPAL_SCHEMA="drupal_${JOBID}"
CIVICRM_SCHEMA="civicrm_${JOBID}"

echo "Creating databases with the suffix -'_${JOBID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
create database ${DRUPAL_SCHEMA};
create database ${CIVICRM_SCHEMA};

grant all on ${DRUPAL_SCHEMA}.* to ${USERNAME}@${BUILD_HOST};
grant all on ${CIVICRM_SCHEMA}.* to ${USERNAME}@${BUILD_HOST};
EOS
