#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

mkdir -p "$TMPDIR_FS"
mkdir -p "$TMPDIR_REGULAR"

chmod 777 "$TMPDIR_FS"
chmod 777 "$TMPDIR_REGULAR"
