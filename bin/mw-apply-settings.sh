#!/bin/bash -ex
LOCAL_SETTINGS="$WORKSPACE/LocalSettings.php"
MEDIAWIKI_D="/srv/slave-scripts/mediawiki/conf.d"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

# Copy under /log for archival purposes
cp "$LOCAL_SETTINGS" "$WORKSPACE/log"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
