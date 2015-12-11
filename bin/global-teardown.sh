#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

rm -rf "${TMPDIR_FS}"
rm -rf "${TMPDIR_REGULAR}"
