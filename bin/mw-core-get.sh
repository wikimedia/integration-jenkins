#!/bin/bash -xe

# Enable support for "!(exclude_this_dir)" pattern
shopt -s extglob

# Local bare git repository
# On Wikimedia CI server, that is a Gerrit replica
GIT_LOCAL="/srv/ssd/gerrit/mediawiki/core.git"

# git tree-ish passed to git-archve (or gitblit)
TREE_ISH=${1:-'master'}

# Set MW_INSTALL_PATH
. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

# Very basic validation
if [[ ! -d "$MW_INSTALL_PATH" || ! -w "$MW_INSTALL_PATH" ]]; then
	echo "\$MW_INSTALL_PATH must be pointing to a directory"
	exit 1
fi

# mwext-* jobs using this script use Jenkins/scm/git to wipe their worktree
# before fetching mediawik-core. While it uses 'wipe' instead of 'clean', it is
# still scoped to WORKSPACE/extensions/Foo, so WORKSPACE itself never gets
# wiped, cleaned or reset. We can't do a wide spectrum `rm -rf *` because this
# script runs after WORKSPACE/extensions/Foo is already cloned and set up, we
# we need to preserve that.
# FIXME: One down-side here is that, while extensions/ is just a stub in
# mediawiki-core, it does have some files, so those would still get left behind.
# FIXME: This also doesn't delete dotfiles (! implies *, which doesn't include
# dotfiles by default).
# See bug 66429.
pushd .
cd $MW_INSTALL_PATH  && rm -rf !(extensions)
popd

if [ -d "$GIT_LOCAL" ]; then
	# Record the exact commit fetched on stderr via 'git get-tar-commit-id'
	git archive --remote="$GIT_LOCAL" "$TREE_ISH" \
		| tee >(git get-tar-commit-id 1>&2 ; cat > /dev/null ) \
		| (cd "$MW_INSTALL_PATH" && tar xf -)
else
	# Fallback to git.wikimedia.org
	curl "https://git.wikimedia.org/zip/?r=mediawiki/core.git&format=gz&h=$TREE_ISH" \
		| (cd "$MW_INSTALL_PATH" && tar xzf -)
fi

# HACK: After https://gerrit.wikimedia.org/r/#/c/119941/ we need to bring
# mediawiki/vendor.git into $MW_INSTALL_PATH as well for the PSR-3 interfaces.
VENDOR_LOCAL="/srv/ssd/gerrit/mediawiki/vendor.git"
VENDOR_INSTALL_PATH="${MW_INSTALL_PATH}/vendor"
mkdir $VENDOR_INSTALL_PATH
if [ -d "$VENDOR_LOCAL" ]; then
	# Record the exact commit fetched on stderr via 'git get-tar-commit-id'
	git archive --remote="$VENDOR_LOCAL" "$TREE_ISH" \
		| tee >(git get-tar-commit-id 1>&2 ; cat > /dev/null ) \
		| (cd "$VENDOR_INSTALL_PATH" && tar xf -)
else
	# Fallback to git.wikimedia.org
	curl "https://git.wikimedia.org/zip/?r=mediawiki/vendor.git&format=gz&h=$TREE_ISH" \
		| (cd "$VENDOR_INSTALL_PATH" && tar xzf -)
fi
