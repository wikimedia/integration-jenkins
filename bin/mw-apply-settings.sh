#!/bin/bash -ex
LOCAL_SETTINGS="$WORKSPACE/LocalSettings.php"
MEDIAWIKI_D="/srv/slave-scripts/mediawiki/conf.d"

# Setup Junit destination
LOG_DIR="$WORKSPACE/log"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

# Copy under /log for archival purposes
mkdir -p "$LOG_DIR"
cp "$LOCAL_SETTINGS" "$LOG_DIR"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
