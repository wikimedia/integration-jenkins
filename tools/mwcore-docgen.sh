#!/bin/bash -e
#
# A wrapper around MediaWiki core documentation generator used to creates
# documentation for master, release branches and release tags.
#
# Copyright, All rights reserved.
# - Wikimedia Foundation, 2012-2013
# - Antoine "hashar" Musso, 2012-2013
# - Timo Tijhof, 2012-2013
#
# Licensed under GPL v2.0


# Will hold the tag or branch
TARGET_NAME=""

if [[ "$ZUUL_REF" =~ ^refs/tags/(.*) ]]; then
	TARGET_NAME="${BASH_REMATCH[1]}"
elif [[ "$ZUUL_REF" =~ ^(master|REL[0-9]+_[0-9]+)$ ]]; then
	TARGET_NAME="${BASH_REMATCH[1]}"
fi

if [ -z "$TARGET_NAME" ]; then
	echo "Error: Change target reference is not a tag or a recognized branch."
	echo "\$ZUUL_REF: $ZUUL_REF"
	exit 1
fi

if [ ! -e  "$WORKSPACE/maintenance/mwdocgen.php" ]; then
	echo "Error: Could not find maintenance/mwdocgen.php"
	echo "Make sure \$WORKSPACE points to a MediaWiki installation."
	echo "\$WORKSPACE: $WORKSPACE"
	exit 1
fi

echo "Found target: '$TARGET_NAME'"

# Destination where the generated files will eventually land.
# For example:
# http://doc.wikimedia.org/mediawiki-core/master/php
# http://doc.wikimedia.org/mediawiki-core/REL1_20/php
# http://doc.wikimedia.org/mediawiki-core/1.20.2/php
DEST_DIR="/srv/org/wikimedia/doc/mediawiki-core/$TARGET_NAME/php"
[ ! -d "${DEST_DIR}" ] && mkdir -p "${DEST_DIR}"

# Run the MediaWiki documentation wrapper
#
# We want to make sure both stdin and stderr are logged to publicly accessible
# files so users can have a look at them directly from the doc site.
# We also send back the stderr to the Jenkins console
#
# Trick explanation: the command stderr is sent as stdin to a tee FIFO which in
# turns write back to stderr.
php "$WORKSPACE/maintenance/mwdocgen.php" \
	--no-extensions --output "$DEST_DIR" \
	1 > "$DEST_DIR/console.txt" \
	2 > >(tee "$DEST_DIR/errors.txt" >&2)
