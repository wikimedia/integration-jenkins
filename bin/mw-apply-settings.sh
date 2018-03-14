#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

LOCAL_SETTINGS="${MW_INSTALL_PATH}/LocalSettings.php"
MEDIAWIKI_D="/srv/deployment/integration/slave-scripts/mediawiki/conf.d"

# Apache lacks env variables, and we need MediaWiki to point to the proper
# setup for example for the localisation cache.
#
# Inject the variable set via mw-set-env / global-set-env T120356
#
echo "Setting \$wgTmpDirectory = '${MW_TMPDIR}';"
# No PHP tags since _join.php inject them
echo -en "\$wgTmpDirectory = '${MW_TMPDIR}';\n" >> "$LOCAL_SETTINGS"

php "$MEDIAWIKI_D/_join.php" >> "$LOCAL_SETTINGS"

echo "Making sure $LOCAL_SETTINGS is still valid"
php -l "$LOCAL_SETTINGS"
cp "$LOCAL_SETTINGS" "$LOG_DIR/"
