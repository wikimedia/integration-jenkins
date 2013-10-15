#!/bin/bash -xe
# This script used to be a Jenkins Job Builder macro 'mw-phpunit-allexts'
#
# References:
# bug: 42506
# bug: 48147
# Ib0fdffb97cdf237a49b43d7abaa81b81afe8c499

LOGS_DIR="$WORKSPACE/logs"
mkdir -p "$LOGS_DIR"
JUNIT_DEST="$LOGS_DIR/junit-phpunit-allexts.xml"

# We have to move to the tests/phpunit directory where suite.xml is located or
# the relative paths referenced in that file will not get properly resolved by
# PHPUnit
# The Jenkins publishers are usually expecting the .xml file to be at the root
# of the workspace, so make sure we use an absolute path.
cd "$WORKSPACE/tests/phpunit"

php phpunit.php --log-junit "$JUNIT_DEST" --testsuite extensions
