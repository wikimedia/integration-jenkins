#!/bin/bash -ex

# Fallbacks for env variables exported in gerrit-sync-ve-push.sh
GERRIT_USER_SSH_IDENTITY=${GERRIT_USER_SSH_IDENTITY:-'/var/lib/jenkins/.ssh/jenkins-mwext-sync_id_rsa'}
exec ssh -i "$GERRIT_USER_SSH_IDENTITY" "$@"
