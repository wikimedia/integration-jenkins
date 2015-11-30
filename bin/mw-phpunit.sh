#!/bin/bash
#
# Wrapper around MediaWiki PHPUnit entry point with env based configuration
#
# Example usage:
#
# PHPUNIT_EXCLUDE_GROUP=ParserTests mw-phpunit.sh
# PHPUNIT_TESTSUITE=extensions mw-phpunit.sh

set -e
set -u

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

PHPUNIT_DIR=${PHPUNIT_DIR:-/srv/deployment/integration/phpunit/vendor/phpunit/phpunit}
JUNIT_DEST="$LOG_DIR/junit-mw-phpunit.xml"

PHPUNIT_GROUP=${PHPUNIT_GROUP:-}
PHPUNIT_EXCLUDE_GROUP=${PHPUNIT_EXCLUDE_GROUP:-}
PHPUNIT_TESTSUITE=${PHPUNIT_TESTSUITE:-}

phpunit_args=()
[[ "$PHPUNIT_GROUP" ]] && phpunit_args+=('--group' "${PHPUNIT_GROUP}")
[[ "$PHPUNIT_EXCLUDE_GROUP" ]] && phpunit_args+=('--exclude-group' "$PHPUNIT_EXCLUDE_GROUP")
[[ "$PHPUNIT_TESTSUITE" ]] && phpunit_args+=('--testsuite' "${PHPUNIT_TESTSUITE}")


set -x
cd "${MW_INSTALL_PATH}/tests/phpunit"

php phpunit.php \
	--with-phpunitdir "$PHPUNIT_DIR" \
	--conf "$MW_INSTALL_PATH/LocalSettings.php" \
	--log-junit $JUNIT_DEST \
	"${phpunit_args[@]}"
