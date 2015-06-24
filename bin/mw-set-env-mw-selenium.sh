#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

export MW_SERVER="http://localhost:9412"
export MW_SCRIPT_PATH="/$BUILD_TAG"

export HEADLESS=true
export HEADLESS_DISPLAY="${DISPLAY##*:}"
export HEADLESS_DESTROY_AT_EXIT=false

export MEDIAWIKI_ENVIRONMENT=integration
export MEDIAWIKI_URL="${MW_SERVER}/wiki"
