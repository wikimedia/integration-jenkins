<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/10_env_mw_install_path.php
#

# set MW_INSTALL_PATH to WORKSPACE when unset

# The Wikidata extension has its extensions under /extensions/Wikidata/vendor/*
# That causes a bunch of issues when using relative paths.

if( ! getenv( 'MW_INSTALL_PATH' ) ) {
	putenv( 'MW_INSTALL_PATH='. getenv( 'WORKSPACE' ) );
}
