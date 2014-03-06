#!/bin/bash -e
# Runs a MediaWiki PHPUnit group
#
# By default it will run all tests besides the one listed in
# PHPUNIT_EXCLUDE_GROUP.
#
# Passing 'databaseless' or 'misc' will run buildin list of tests
#
# This script replaces ant targets that were available in
# integration/jenkins.git under /jobs/_shared/build.xml
#

#######################################################################
# Configuration
#######################################################################

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

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
PHPUNIT_DIR="/srv/deployment/integration/phpunit/vendor/phpunit/phpunit"

# Setup Junit destination
LOG_DIR="$WORKSPACE/log"
mkdir -p "$LOG_DIR"
JUNIT_DEST="$LOG_DIR/junit-mw-phpunit.xml"

# Make sure to compress MediaWiki log dir after phpunit has ran
function compress_log_dir() {
    echo "Compressing logs under $LOG_DIR"
	gzip --verbose --force --best "$LOG_DIR"/*.log || :
}
trap compress_log_dir EXIT

set -x
cd "${MW_INSTALL_PATH}/tests/phpunit"
hhvm --php phpunit.php \
	--with-phpunitdir "$PHPUNIT_DIR" \
	--conf "$MW_INSTALL_PATH/LocalSettings.php" \
	--log-junit $JUNIT_DEST
