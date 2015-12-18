#!/bin/bash -eu

. /srv/deployment/integration/slave-scripts/bin/global-set-env.sh

stat "${TMPDIR_FS}" || :
stat "${TMPDIR_REGULAR}" || :

rm -v -rf "${TMPDIR_FS}"
rm -v -rf "${TMPDIR_REGULAR}"
