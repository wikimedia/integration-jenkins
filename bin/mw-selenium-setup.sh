#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-mw-selenium.sh

mkdir -p "$TMPDIR_FS"
mkdir -p "$TMPDIR_REGULAR"

# Append the MW installation's LocalSettings.php with the contents of
# tests/browser/LocalSettings.php. Note that this setup script requires that
# the current working directory already be the appropriate `tests/browser`
# directory.
if [ -f LocalSettings.php ]; then
	cat LocalSettings.php >> "$MW_INSTALL_PATH/LocalSettings.php"
fi
