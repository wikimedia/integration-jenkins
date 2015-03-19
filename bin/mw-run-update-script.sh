#!/bin/bash -eux

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

php "$MW_INSTALL_PATH/maintenance/update.php" --quick
