#!/bin/bash -e

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

LOCAL_SETTINGS="${MW_INSTALL_PATH}/LocalSettings.php"
MEDIAWIKI_D="/srv/deployment/integration/slave-scripts/mediawiki/conf.d"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

# Copy LocalSettings under /log for archival purposes
cp "$LOCAL_SETTINGS" "$LOG_DIR"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
