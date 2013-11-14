#!/bin/bash
#
# Wrapper to run PHP CodeSniffer with MediaWiki coding style
#
# Copyright 2013 Antoine "hashar" Musso
# Copyright 2013 Wikimedia Foundation Inc.
#
#
# Since phpcs is a bit long, we want to be able to run it only on files
# modified in HEAD. Passing 'head' as an argument would enable that.
#
# In 'head' mode, if no files match the extensions in PHP_EXTS, the script will
# abort early with exit code 0.  That let us skip the job entirely.
#
# We also want to be able to ignore warnings while they are being fixed up. One
# can pass 'nowarnings' as an argument to instruct phpcs to skip them and only
# care about errors.
#
# Possibles calls are thus:
#
# Process all PHP files and whine on errors and warnings:
#
#   run-phpcs-mw
#
# Process all PHP files but only whine on errors:
#
#   run-phpcs-mw nowarnings
#
# Only care about files modified in HEAD:
#
#   run-phpcs-mw head
#
# Same but only whining on errors:
#
#   run-phpcs-mw head nowarnings
#

# Whether to use git-changed-in-head to restrict files phpcs will be run upon
HEAD_ONLY=false

# Whether to print warnings (false would invoke `phpcs -n`)
WARNINGS=true

# File extensions to look for.
# In head mode, that is passed to git-changed-in-head
# Else it is passed to phpcs --extensions
PHP_EXTS=('php' 'php5' 'inc' 'sample')
PHP_EXTS_WITH_SEP=$(IFS=,; echo "${PHP_EXTS[*]}")

# Full path to phpcs
#
# It is deployed on Jenkins slaves from integration/phpcs.git using Wikimedia
# deployment system.
PHPCS="/srv/deployment/integration/phpcs/vendor/bin/phpcs"

# Full path to MediaWiki CodeSniffer style
#
# It is deployed on Jenkins slaves from mediawiki/tools/codesniffer.git using
# Wikimedia deployment system.
PHPCS_STANDARD="/srv/deployment/integration/mediawiki-tools-codesniffer/MediaWiki"

# Extra options to pass to phpcs
PHPCS_OPTS=""

# Filepatterns to ignore
IGNORE=('languages/messages/Messages' '*.i18n.php' '*.i18n.alias.php')
IGNORE_WITH_SEP=$(IFS=,; echo "${IGNORE[*]}")

for arg in "$@"; do
	[[ "$arg" == "head" ]] && HEAD_ONLY=true
	[[ "$arg" == "HEAD" ]] && HEAD_ONLY=true
	[[ "$arg" == "nowarnings" ]] && WARNINGS=false
done

if $HEAD_ONLY; then
	PHPCS_FILES=$(/srv/slave-scripts/bin/git-changed-in-head "${PHP_EXTS[@]}")
	if [[ -z "$PHPCS_FILES" ]]; then
		echo "Skipping phpcs run on HEAD: no file matching '$PHP_EXTS'"
		exit 0
	fi
	echo "Will only parse files changed in HEAD: $PHPCS_FILES"
else
	# Fall back to current directory (should be Jenkins workspace)
	echo "Will parse $PHP_EXTS_WITH_SEP files in current directory."
	PHPCS_FILES='.'
	PHPCS_OPTS="$PHPCS_OPTS --extensions=$PHP_EXTS_WITH_SEP"
fi

if [[ $WARNINGS == false ]]; then
	echo "Will ignore warnings."
	PHPCS_OPTS="$PHPCS_OPTS -n"
fi

echo "Starting PHPCS..."
set -xe
$PHPCS -v -s $PHPCS_FILES \
	--encoding=utf-8 \
	--standard=$PHPCS_STANDARD \
	$PHPCS_OPTS \
	--ignore=$IGNORE_WITH_SEP \
	--report-checkstyle=checkstyle-phpcs.xml \
	--report-full
