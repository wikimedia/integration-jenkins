#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-mw-selenium.sh

# Cleanup/recreate the TMPDIR since it's not a tmpfs location
if test -d "$TMPDIR"; then
	rm -rf "$TMPDIR"
fi

mkdir "$TMPDIR"
