#!/bin/bash -eu

# Load require-dev packages on top of mediawiki/vendor (T112895)
# Once jq 1.4 is available, the following may be used instead:
# > jq -r '.["require-dev"]|to_entries|map([.key,.value])[]|join("=")' ../composer.json
set -o pipefail
node $(dirname $0)/../tools/composer-dev-args.js "composer.json" | xargs composer require --dev --ansi --no-progress --prefer-dist -v
