#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

cd "$MW_INSTALL_PATH/vendor"

# Load require-dev packages on top of mediawiki/vendor (T112895)
set -o pipefail
jq -r '.["require-dev"]|to_entries|map([.key,"\"" + .value + "\""])[]|join("=")' "$MW_INSTALL_PATH/composer.json" | xargs --verbose composer require --dev --ansi --no-progress --prefer-dist -v

# Point composer-merge-plugin to mediawiki/core to have it to merge
# autoload-dev. T158674
if [ "${MW_COMPOSER_MERGE_MW_IN_VENDOR:-}" ] && [ -f "$MW_INSTALL_PATH/composer.json" ]; then
	composer config extra.merge-plugin.include "$MW_INSTALL_PATH/composer.json"
fi

mkdir -p "$LOG_DIR"
[ -f "$MW_INSTALL_PATH/composer.json" ] && cp -vf "$MW_INSTALL_PATH/composer.json" "$LOG_DIR/composer.core.json.txt" || :
[ -f "$MW_INSTALL_PATH/vendor/composer.json" ] && cp -vf "$MW_INSTALL_PATH/vendor/composer.json" "$LOG_DIR/composer.vendor.json.txt" || :
[ -f "$MW_INSTALL_PATH/vendor/composer/autoload_files.php" ] && cp -vf "$MW_INSTALL_PATH/vendor/composer/autoload_files.php" "$LOG_DIR/composer.autoload_files.php.txt" || :
