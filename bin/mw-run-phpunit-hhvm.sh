#!/bin/bash -e

# Runs a MediaWiki PHPUnit group
#
# By default it will run all tests besides the one listed in
# PHPUNIT_EXCLUDE_GROUP.
#
# Passing 'databaseless' or 'misc' will run buildin list of tests

#######################################################################
# Configuration
#######################################################################

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

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
#
PHPUNIT_DIR=${PHPUNIT_DIR:-/srv/deployment/integration/phpunit/vendor/phpunit/phpunit}

# Setup Junit destination
JUNIT_DEST="$LOG_DIR/junit-mw-phpunit.xml"

set -x
cd "${MW_INSTALL_PATH}/tests/phpunit"
hhvm -vEval.Jit=1 \
	-vEval.PerfPidMap=false \
	-vDebug.CoreDumpReportDirectory="$LOG_DIR" \
	-vRepo.Central.Path="$WORKSPACE/hhvm.hhbc.sqlite" \
	--php phpunit.php \
	--with-phpunitdir "$PHPUNIT_DIR" \
	--conf "$MW_INSTALL_PATH/LocalSettings.php" \
	--log-junit $JUNIT_DEST
