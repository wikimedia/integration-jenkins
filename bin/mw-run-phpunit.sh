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

# MediaWiki known PHPUnit groups
PHPUNIT_GROUPS="API,Database,Dump,Parser"

# Always exclude some groups:
# - Broken : tests explicitly marked as non working
# - ParserFuzz : keep running, mostly for dev/ spotting bugs
# - Stub : not implemented tests
PHPUNIT_EXCLUDE_GROUP="Broken,ParserFuzz,Stub"

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

#######################################################################
# Start of code
#######################################################################

PHPUNIT_GROUPS_TO_RUN=""

# FIXME: this is all hardcoded :-(

if [ $# -eq 0 ]; then
	echo "No argument given, Will run all tests."
	PHPUNIT_GROUPS_TO_RUN=""

elif [ "$1" == "api" ]; then
	PHPUNIT_GROUPS_TO_RUN="API"

elif [ "$1" == "databaseless" ]; then
	PHPUNIT_EXCLUDE_GROUP="Database,$PHPUNIT_EXCLUDE_GROUP"

elif [ "$1" == "misc" ]; then
	PHPUNIT_GROUPS_TO_RUN="Database"
	# Exclude all known groups but the Database one since we want to run it
	PHPUNIT_EXCLUDE_GROUP="${PHPUNIT_GROUPS/'Database,'/},$PHPUNIT_EXCLUDE_GROUP"

elif [ "$1" == "parser" ]; then
	PHPUNIT_GROUPS_TO_RUN="Parser"

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
cd "${MW_INSTALL_PATH}/tests/phpunit"
$PHP_BIN phpunit.php \
	--with-phpunitdir "$PHPUNIT_DIR" \
	$PHPUNIT_GROUP_OPT \
	--exclude-group "$PHPUNIT_EXCLUDE_GROUP" \
	--conf "$MW_INSTALL_PATH/LocalSettings.php" \
	--log-junit $JUNIT_DEST
