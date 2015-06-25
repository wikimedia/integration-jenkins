#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-localhost.sh

export HEADLESS=true
export HEADLESS_DISPLAY="${DISPLAY##*:}"
export HEADLESS_DESTROY_AT_EXIT=false

export MEDIAWIKI_ENVIRONMENT=integration
export MEDIAWIKI_URL="${MW_SERVER}${MW_SCRIPT_PATH}/index.php"
export MEDIAWIKI_API_URL="${MW_SERVER}${MW_SCRIPT_PATH}/api.php"
