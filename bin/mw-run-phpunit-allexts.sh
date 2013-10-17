#!/bin/bash -xe
# This script used to be a Jenkins Job Builder macro 'mw-phpunit-allexts'
#
# References:
# bug: 42506
# bug: 48147
# Ib0fdffb97cdf237a49b43d7abaa81b81afe8c499

LOG_DIR="$WORKSPACE/log"
mkdir -p "$LOG_DIR"
JUNIT_DEST="$LOG_DIR/junit-phpunit-allexts.xml"

# Make sure to compress MediaWiki log dir after phpunit has ran
function compress_log_dir() {
	echo "Compressing logs under $LOG_DIR"
	gzip --verbose --best "$LOG_DIR"/*.log
}
trap compress_log_dir EXIT

# We have to move to the tests/phpunit directory where suite.xml is located or
# the relative paths referenced in that file will not get properly resolved by
# PHPUnit
# The Jenkins publishers are usually expecting the .xml file to be at the root
# of the workspace, so make sure we use an absolute path.
cd "$WORKSPACE/tests/phpunit"

php phpunit.php --log-junit "$JUNIT_DEST" --testsuite extensions
