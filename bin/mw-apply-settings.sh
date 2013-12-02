#!/bin/bash -ex
LOCAL_SETTINGS="$WORKSPACE/LocalSettings.php"
MEDIAWIKI_D="/srv/deployment/integration/slave-scripts/mediawiki/conf.d"

# Setup Junit destination
LOG_DIR="$WORKSPACE/log"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

# Empty out the logs directory
rm -fR "$LOG_DIR"
mkdir -p "$LOG_DIR"

# Copy LocalSettings under /log for archival purposes
cp "$LOCAL_SETTINGS" "$LOG_DIR"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
