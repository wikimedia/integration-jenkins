#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-setup.sh
. /srv/deployment/integration/slave-scripts/bin/mw-set-env.sh

# Ensure LocalSettings does not exist
rm -f "$MW_INSTALL_PATH/LocalSettings.php"

# Ensure we won't include logs from previous builds
# Also prevents post-build jUnitArchiver exceptions about old log files (T93993)
rm -rf "$LOG_DIR"

# Re-create log directory
mkdir -p "$LOG_DIR"
# Make it writable by Apache (for http requests)
chmod 777 "$LOG_DIR"
