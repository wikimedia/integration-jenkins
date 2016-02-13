#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

cd "$MW_INSTALL_PATH/vendor"

# Load require-dev packages on top of mediawiki/vendor (T112895)
# Once jq 1.4 is available, the following may be used instead:
# > jq -r '.["require-dev"]|to_entries|map([.key,.value])[]|join("=")' ../composer.json
node $(dirname $0)/../tools/composer-dev-args.js "$MW_INSTALL_PATH/composer.json" | xargs composer require --dev --ansi --no-progress --prefer-dist -v

# FIXME: integration/composer is outdated and breaks autoloader
# Once we're on composer 1.0.0-alpha11 or higher this might not
# be needed anymore
composer dump-autoload --optimize
