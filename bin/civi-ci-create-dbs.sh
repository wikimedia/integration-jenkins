#!/bin/bash

if [ "x${JOB_NAME}" = "x" ]; then
	echo "JOB_NAME environment variable was not set, exiting."
	exit 1
fi
if [ "x${BUILD_NUMBER}" = "x" ]; then
	echo "BUILD_NUMBER environment variable was not set, exiting."
	exit 1
fi

# MYSQL database name cant use spaces or dashes:
JOB_ID="${JOB_NAME// /_}_${BUILD_NUMBER}"
JOB_ID="${JOB_ID//-/_}"

BUILD_HOST=`hostname`
USERNAME="civitest_${JOB_ID}"
PASSWORD="pw_${JOB_ID}"
DRUPAL_SCHEMA="drupal_${JOB_ID}"
CIVICRM_SCHEMA="civicrm_${JOB_ID}"

echo "Creating databases with the suffix -'_${JOB_ID}'"

mysql -u root <<EOS
drop database if exists ${DRUPAL_SCHEMA};
drop database if exists ${CIVICRM_SCHEMA};
create database ${DRUPAL_SCHEMA};
create database ${CIVICRM_SCHEMA};

grant all on ${DRUPAL_SCHEMA}.* to ${USERNAME}@${BUILD_HOST};
grant all on ${CIVICRM_SCHEMA}.* to ${USERNAME}@${BUILD_HOST};
EOS
