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
