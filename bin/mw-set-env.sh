#!/bin/bash -x
#
# Script to set up various environement variables suitable to test out
# MediaWiki core and extensions on Wikimedia continuous integration platform.

# allow the dumping of corefiles, up to 2GB
ulimit -c 2097152

MW_INSTALL_PATH=$WORKSPACE
for mw_path in src/mediawiki/core src; do
	if [[ -d "$WORKSPACE/$mw_path" ]]; then
		MW_INSTALL_PATH="$WORKSPACE/$mw_path"
		break
	fi;
done;
export MW_INSTALL_PATH

# All slaves should have tmpfs mounted, use if available
if [ -d "$HOME/tmpfs" ]; then
	# Don't use JOB_NAME since that is not unique when running concurrent builds (T91070).
	# Instead use the trailing part of $WORKSPACE which will be 'foo', 'foo@2'.
	# Trailing slash is important there.
	export TMPDIR="$HOME/tmpfs/`basename $WORKSPACE`"
	export MW_TMPDIR="$TMPDIR"
else
	export MW_TMPDIR="$WORKSPACE/data"
fi

export LOG_DIR="$WORKSPACE/log"

# Create logs direcotry
# Make it writable by apache (for web requests such as from qunit tests)
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"
