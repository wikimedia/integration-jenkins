#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

cd "$MW_INSTALL_PATH/vendor"

# Load require-dev packages on top of mediawiki/vendor (T112895)
# Once jq 1.4 is available, the following may be used instead:
# > jq -r '.["require-dev"]|to_entries|map([.key,.value])[]|join("=")' ../composer.json
set -o pipefail
node $(dirname $0)/../tools/composer-dev-args.js "$MW_INSTALL_PATH/composer.json" | xargs --verbose composer require --dev --ansi --no-progress --prefer-dist -v

# Point composer-merge-plugin to mediawiki/core to have it to merge
# autoload-dev. T158674
if [ "${MW_COMPOSER_MERGE_MW_IN_VENDOR:-}" ] && [ -f "$MW_INSTALL_PATH/composer.json" ]; then
	composer config extra.merge-plugin.include "$MW_INSTALL_PATH/composer.json"
fi

# FIXME: integration/composer is outdated and breaks autoloader
# Once we're on composer 1.0.0-alpha11 or higher this might not
# be needed anymore
composer dump-autoload --optimize

mkdir -p "$LOG_DIR"
[ -f "$MW_INSTALL_PATH/composer.json" ] && cp -vf "$MW_INSTALL_PATH/composer.json" "$LOG_DIR/composer.core.json.txt" || :
[ -f "$MW_INSTALL_PATH/vendor/composer.json" ] && cp -vf "$MW_INSTALL_PATH/vendor/composer.json" "$LOG_DIR/composer.vendor.json.txt" || :
[ -f "$MW_INSTALL_PATH/vendor/composer/autoload_files.php" ] && cp -vf "$MW_INSTALL_PATH/vendor/composer/autoload_files.php" "$LOG_DIR/composer.autoload_files.php.txt" || :
