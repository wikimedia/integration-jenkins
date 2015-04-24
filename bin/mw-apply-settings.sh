#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

LOCAL_SETTINGS="${MW_INSTALL_PATH}/LocalSettings.php"
MEDIAWIKI_D="/srv/deployment/integration/slave-scripts/mediawiki/conf.d"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
