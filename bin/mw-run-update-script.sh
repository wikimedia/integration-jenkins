#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

ARGS="--quick"
if [ "${ZUUL_PROJECT:-}" = "mediawiki/vendor" ]
then
	ARGS="$ARGS --skip-external-dependencies"
fi
php "$MW_INSTALL_PATH/maintenance/update.php" $ARGS

