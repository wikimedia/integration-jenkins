#!/bin/bash -xe
#
# Script to update VisualEditor extension in mediawiki/extensions.git
#
# The script interacts with Gerrit using the jenkins-bot credentials which
# belong to the user jenkins on gallium.  The Jenkins job invoking this script
# must be tied to gallium and the jenkins-slave needs a sudo policy to be able
# to run this script as the jenkins user (to access jenkins-bot ssh
# credentials).
#
# The script should be run via a job triggered in the Zuul 'postmerge'
# pipeline. Zuul will provide the merged commit in the ZUUL_COMMIT parameter
# which is exposed in the Jenkins job as the $ZUUL_COMMIT env variable.

MWEXT_DIR='src/extensions'
MWEXT_REPO_ANON="https://gerrit.wikimedia.org/r/p/mediawiki/extensions.git"
export GIT_COMMITTER_EMAIL="jenkins-bot@wikimedia.org"
export GIT_COMMITTER_NAME="jenkins-bot"

if [[ -z "${ZUUL_COMMIT}" ]]; then
	echo "\$ZUUL_COMMIT must be set!"
	exit 1
fi

if [[ "$USER" != "jenkins-slave" ]]; then
	echo "Must be run as 'jenkins-slave' just like any script"
	exit 1
fi

# Initialize mediawiki/extensions checkout with no submodules
echo
mkdir -p "${MWEXT_DIR}"
cd "${MWEXT_DIR}"
git init
git remote add origin "${MWEXT_REPO_ANON}" ||
	git remote set-url origin "${MWEXT_REPO_ANON}"

git fetch --recurse-submodules=no --verbose origin
git reset --hard origin/master

# Initialize VisualEditor submodule
echo
pwd
git submodule update --init VisualEditor
cd VisualEditor
VE_OLD_SHORT=`git rev-parse --short HEAD`
VE_OLD_LONG=`git rev-parse HEAD`
if [[ ${VE_OLD_LONG} == ${ZUUL_COMMIT} ]]; then
	echo "VisualEditor is already pointing to Zuul commit version:"
	echo "HEAD.........: ${VE_OLD_LONG}"
	echo "ZUUL_COMMIT..: ${ZUUL_COMMIT}"
	exit 1
fi
git fetch origin
git reset --hard "${ZUUL_COMMIT}"
ZUUL_COMMIT_SHORT=`git rev-parse --short HEAD`
git log -n1 --format=fuller --color
cd ..

# Add change to Gerrit
echo
pwd
git add VisualEditor
git commit -a -m "Syncronize VisualEditor: ${VE_OLD_SHORT}..${ZUUL_COMMIT_SHORT}"
git show

# Install commit hook if needed
if [ ! -e ".git/hooks/commit-msg" ]; then
	curl 'https://gerrit.wikimedia.org/r/tools/hooks/commit-msg' > `git rev-parse --git-dir`/hooks/commit-msg
fi

echo "Done updating locally. Commit should now be pushed. Use gerrit-sync-ve-push.sh."
