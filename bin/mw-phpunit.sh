#!/bin/bash -eu
#
# Wrapper around MediaWiki PHPUnit entry point with env based configuration
#
# Example usage:
#
# PHPUNIT_EXCLUDE_GROUP=ParserTests mw-phpunit.sh
# PHPUNIT_TESTSUITE=extensions mw-phpunit.sh

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

JUNIT_DEST="$LOG_DIR/junit-mw-phpunit.xml"

# The MediaWiki php wrapper defaults to using the local PHPUnit from Composer.
PHPUNIT_DIR=${PHPUNIT_DIR:-}
PHPUNIT_GROUP=${PHPUNIT_GROUP:-}
PHPUNIT_EXCLUDE_GROUP=${PHPUNIT_EXCLUDE_GROUP:-}
PHPUNIT_TESTSUITE=${PHPUNIT_TESTSUITE:-}

phpunit_args=()

[[ "$PHPUNIT_DIR" ]] && phpunit_args+=('--with-phpunitdir ' "${PHPUNIT_DIR}")

[[ "$PHPUNIT_GROUP" ]] && phpunit_args+=('--group' "${PHPUNIT_GROUP}")

# Always exclude some groups:
# - Broken : tests explicitly marked as non working
# - ParserFuzz : keep running, mostly for dev/ spotting bugs
# - Stub : not implemented tests
# --exclude-group would override ignored groups from suite.xml
[[ "$PHPUNIT_EXCLUDE_GROUP" ]] && phpunit_args+=('--exclude-group' "Broken,ParserFuzz,Stub,$PHPUNIT_EXCLUDE_GROUP")

[[ "$PHPUNIT_TESTSUITE" ]] && phpunit_args+=('--testsuite' "${PHPUNIT_TESTSUITE}")


set -x
cd "${MW_INSTALL_PATH}/tests/phpunit"

$PHP_BIN phpunit.php \
	--log-junit $JUNIT_DEST \
	"${phpunit_args[@]:-}"
