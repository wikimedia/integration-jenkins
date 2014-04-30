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

if [ -d "$GIT_LOCAL" ]; then
	# Record the exact commit fetched on stderr via 'git get-tar-commit-id'
	git archive --remote="$GIT_LOCAL" "$TREE_ISH" \
		| tee >(git get-tar-commit-id 1>&2 ; cat > /dev/null ) \
		| (cd "$WORKSPACE" && tar xf -)
else
	# Fallback to git.wikimedia.org
	curl "https://git.wikimedia.org/zip/?r=mediawiki/core.git&format=gz&h=$TREE_ISH" \
		| (cd "$WORKSPACE" && tar xzf -)
fi
