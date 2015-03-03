#!/bin/bash -eux

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

# Teardown directory created by mw-set-env.sh / mw-install-sqlite.sh
rm -rf "$MW_TMPDIR"
