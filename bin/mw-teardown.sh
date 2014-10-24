#!/bin/bash -eux

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

# Teardown sqlite DB created via mw-install-sqlite.sh
rm -f "${MW_DB_PATH}/${MW_DB_NAME}.sqlite"
