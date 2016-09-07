#!/bin/bash -eu
#
# This script used to be a Jenkins Job Builder macro 'mw-phpunit-allexts'
#
# References: T44506, T50147

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

JUNIT_DEST="$LOG_DIR/junit-phpunit-allexts.xml"

# We have to move to the tests/phpunit directory where suite.xml is located or
# the relative paths referenced in that file will not get properly resolved by
# PHPUnit
# The Jenkins publishers are usually expecting the .xml file to be at the root
# of the workspace, so make sure we use an absolute path.

set -x
cd "${MW_INSTALL_PATH}/tests/phpunit"

php -dzend.enable_gc=0 \
	phpunit.php \
	--log-junit "$JUNIT_DEST" \
	--testsuite extensions
