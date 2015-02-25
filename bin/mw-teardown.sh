#!/bin/bash -eux

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

# Teardown tmp db dir created via mw-set-env.sh / mw-install-sqlite.sh
rm -rf "${MW_DB_PATH}"
