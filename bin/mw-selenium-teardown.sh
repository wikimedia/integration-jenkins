#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/mw-set-env-mw-selenium.sh

# Have bash '*' to expand dot files as well.
# We keep the directory see bin/global-teardown.sh and T120824
shopt -s dotglob
rm -rf "$TMPDIR"/*
