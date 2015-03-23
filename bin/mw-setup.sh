#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-setup.sh
. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"
