#!/bin/bash -e
#
# A wrapper around MediaWiki core documentation generator used to creates
# documentation for master, release branches and release tags.
#
# Copyright, All rights reserved.
# - Wikimedia Foundation, 2012-2014
# - Antoine "hashar" Musso, 2012-2014
# - Timo Tijhof, 2012-2013
#
# Licensed under GPL v2.0

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

TARGET_BASEDIR={TARGET_BASEDIR:-/srv/org/wikimedia/doc}
TARGET_PROJECTDIR=`echo "$ZUUL_PROJECT" | tr '/' '-'`
TARGET_VERSIONDIR=""

if [ -z "$TARGET_PROJECTDIR" ]; then
	echo "Error: Project name not found."
	echo "\$ZUUL_PROJECT: $ZUUL_PROJECT"
	exit 1
fi

# Example values:
# - ZUUL_REF: refs/zuul/master/Z74178670e7c5495199f8a92e92cf609c
# - ZUUL_BRANCH: master
if [[ "$ZUUL_REF" =~ ^refs/tags/(.*) ]]; then
	TARGET_VERSIONDIR="${BASH_REMATCH[1]}"
elif [[ "$ZUUL_BRANCH" =~ ^(master|REL[0-9]+_[0-9]+)$ ]]; then
	TARGET_VERSIONDIR="${BASH_REMATCH[1]}"
fi

if [ -z "$TARGET_VERSIONDIR" ]; then
	echo "Error: Change target reference is not a tag or a recognized branch."
	echo "\$ZUUL_REF: $ZUUL_REF"
	echo "\$ZUUL_BRANCH: $ZUUL_BRANCH"
	exit 1
fi

if [ ! -e  "$MW_INSTALL_PATH/maintenance/mwdocgen.php" ]; then
	echo "Error: Could not find maintenance/mwdocgen.php"
	echo "Make sure \$MW_INSTALL_PATH points to a MediaWiki installation."
	echo "\$MW_INSTALL_PATH: $MW_INSTALL_PATH"
	exit 1
fi


# Destination where the generated files will eventually land.
# For example:
# http://doc.wikimedia.org/mediawiki-core/master/php
# http://doc.wikimedia.org/mediawiki-core/REL1_20/php
# http://doc.wikimedia.org/mediawiki-core/1.20.2/php
DEST_DIR="$TARGET_BASEDIR/$TARGET_PROJECTDIR/$TARGET_VERSIONDIR/php"
[ ! -d "${DEST_DIR}" ] && mkdir -p "${DEST_DIR}"

echo "Found target: '$DEST_DIR'"

# Craft a dumb LocalSettings.php which is required by Maintenance script
# albeit the mwdocgen.php script does not require it.
touch "$MW_INSTALL_PATH/LocalSettings.php"

# Run the MediaWiki documentation wrapper
#
# We want to make sure both stdin and stderr are logged to publicly accessible
# files so users can have a look at them directly from the doc site.
# We also send back the stderr to the Jenkins console
#
# Trick explanation: the command stderr is sent as stdin to a tee FIFO which in
# turns write back to stderr.
php "$MW_INSTALL_PATH/maintenance/mwdocgen.php" \
	--no-extensions \
	--output "$DEST_DIR" \
	--version "$TARGET_VERSIONDIR" \
	1> "$DEST_DIR/console.txt" \
	2> >(tee "$DEST_DIR/errors.txt" >&2)
