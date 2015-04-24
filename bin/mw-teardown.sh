#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-teardown.sh
. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

# Copy LocalSettings to /log so that archive-log-dir collects it
cp "${MW_INSTALL_PATH}/LocalSettings.php" "$LOG_DIR"
