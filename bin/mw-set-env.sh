#!/bin/bash
#
# Script to set up various environement variables suitable to test out
# MediaWiki core and extensions on Wikimedia continuous integration platform.

MW_INSTALL_PATH="$WORKSPACE/src/mediawiki/core"
if [[ ! -d "$MW_INSTALL_PATH" ]]; then
	MW_INSTALL_PATH="$WORKSPACE"
fi
export MW_INSTALL_PATH
