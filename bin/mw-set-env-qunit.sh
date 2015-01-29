#!/bin/bash -e

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

export MW_SERVER="http://localhost:9412"
export MW_SCRIPT_PATH="/$BUILD_TAG"
