#!/bin/bash -xe

# Local bare git repository
# On Wikimedia CI server, that is a Gerrit replica
GIT_LOCAL="/srv/ssd/gerrit/mediawiki/core.git"

# git tree-ish passed to git-archve (or gitblit)
TREE_ISH=${1:-'master'}

# Very basic validation
if [[ ! -d "$WORKSPACE" || ! -w "$WORKSPACE" ]]; then
	echo "\$WORKSPACE must be pointing to a directory"
	exit 1
fi

function tar_extract() {
	(cd "$WORKSPACE" && tar xzf -)
}

if [ -d "$GIT_LOCAL"]; then
	git archive --remote="$GIT_LOCAL" "$TREE_ISH" | tar_extract
else
	# Fallback to git.wikimedia.org
	curl "https://git.wikimedia.org/zip/?r=mediawiki/core.git&format=gz&h=$TREE_ISH" | tar_extract
fi
