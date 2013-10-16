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

# MediaWiki known PHPUnit groups
PHPUNIT_GROUPS="API,Database,Dump,Parser"

# Always exclude some groups:
# - Broken : tests explicitly marked as non working
# - ParserFuzz : keep running, mostly for dev/ spotting bugs
# - Stub : not implemented tests
PHPUNIT_EXCLUDE_GROUP="Broken,ParserFuzz,Stub"

# Setup Junit destination
LOG_DIR="$WORKSPACE/log"
mkdir -p "$LOG_DIR"
JUNIT_DEST="$LOG_DIR/junit-mw-phpunit.xml"

#######################################################################
# Start of code
#######################################################################

PHPUNIT_GROUPS_TO_RUN=""

if [ $# -eq 0 ]; then
	echo "No argument given, Will run all tests."
	PHPUNIT_GROUPS_TO_RUN=""

elif [ "$1" == "databaseless" ]; then
	PHPUNIT_EXCLUDE_GROUP="Database,$PHPUNIT_EXCLUDE_GROUP"

elif [ "$1" == "misc" ]; then
	PHPUNIT_GROUPS_TO_RUN="Database"
	# Exclude all known groups but the Database one since we want to run it
	PHPUNIT_EXCLUDE_GROUP="${PHPUNIT_GROUPS/'Database,'/},$PHPUNIT_EXCLUDE_GROUP"

else
	PHPUNIT_GROUPS_TO_RUN=$(IFS=, eval 'echo "$*"')
fi

echo "
PHPUnit groups: $PHPUNIT_GROUPS_TO_RUN
Excluded groups: $PHPUNIT_EXCLUDE_GROUP

Will log to $JUNIT_DEST
"

PHPUNIT_GROUP_OPT=""
if [ "$PHPUNIT_GROUPS_TO_RUN" != "" ]; then
	PHPUNIT_GROUP_OPT="--group $PHPUNIT_GROUPS_TO_RUN"
fi

set -x
cd "${WORKSPACE}/tests/phpunit"
php phpunit.php $PHPUNIT_GROUP_OPT \
	--exclude-group "$PHPUNIT_EXCLUDE_GROUP" \
	--conf "$WORKSPACE/LocalSettings.php" \
	--log-junit $JUNIT_DEST
