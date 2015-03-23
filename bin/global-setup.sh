#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

mkdir -p "$TMPDIR"
chmod 777 "$TMPDIR"
