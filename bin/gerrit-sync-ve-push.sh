#!/bin/bash -xe
#
# Script to push VisualEditor updates to mediawiki/extensions.git

MWEXT_DIR='src/extensions'
MWEXT_REPO_SSH="ssh://${GERRIT_USER}@gerrit.wikimedia.org:29418/mediawiki/extensions.git"
GERRIT_USER='jenkins-mwext-sync'

# Export Gerrit related configuration variables. Will be reused by the git
# shell script wrapper ssh-jenkins-mwext-sync.sh
export GERRIT_USER_SSH_IDENTITY="/var/lib/jenkins/.ssh/jenkins-mwext-sync_id_rsa"

if [[ "$USER" != "jenkins" ]]; then
	echo "Must be run as 'jenkins' user to access $GERRIT_USER SSH credentials"
	exit 1
fi

cd "${MWEXT_DIR}"
git show

# Steps below needs the jenkins-bot credentials and should not write on disk
# since files in the workspace belong to jenkins-slave user.
GIT_SSH="/srv/deployment/integration/slave-scripts/bin/ssh-jenkins-mwext-sync.sh" \
	git push "$MWEXT_REPO_SSH" HEAD:refs/for/master

MWEXT_HEAD=`git rev-parse HEAD`
ssh -i "$GERRIT_USER_SSH_IDENTITY" -p 29418 \
	"${GERRIT_USER}"@gerrit.wikimedia.org "gerrit approve --code-review +2 --verified +2 --submit $MWEXT_HEAD"
