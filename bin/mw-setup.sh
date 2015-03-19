#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

mkdir -p "$MW_TMPDIR"
chmod 777 "$MW_TMPDIR"

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"
