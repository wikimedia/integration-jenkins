#!/bin/bash -e

# This script used to be a Jenkins Job Builder macro 'mw-phpunit-allexts'
#
# References:
# bug: 42506
# bug: 48147
# Ib0fdffb97cdf237a49b43d7abaa81b81afe8c499

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

JUNIT_DEST="$LOG_DIR/junit-phpunit-allexts.xml"

# Path to PHPUnit as deployed by Wikimedia deployment system.
#
# The path is passed to MediaWiki php wrapper using --with-phpunitdir. It
# should match a local checkout of integration/phpunit.git repository which
# contains PHPUnit as it is installed by Composer. The local copy should be
# deployed on all slaves via the role::ci::slave puppet class includes:
# deployment::target { # 'contint-production-slaves': }
#
#
# WARNING: don't forget to update mw-run-phpunit-allexts.sh as well
PHPUNIT_DIR=${PHPUNIT_DIR:-/srv/deployment/integration/phpunit/vendor/phpunit/phpunit}

# We have to move to the tests/phpunit directory where suite.xml is located or
# the relative paths referenced in that file will not get properly resolved by
# PHPUnit
# The Jenkins publishers are usually expecting the .xml file to be at the root
# of the workspace, so make sure we use an absolute path.

cd "${MW_INSTALL_PATH}/tests/phpunit"

set -x
$PHP_BIN phpunit.php \
	--with-phpunitdir "$PHPUNIT_DIR" \
	--log-junit "$JUNIT_DEST" \
	--testsuite extensions
