<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/00_set_debug_log.php
#

if( $wgCommandLineMode ) {
	$wgDebugLogFile = getenv( 'WORKSPACE' ) . '/log/mw-debug-cli.log';
} else {
	# Under Apache, there is no Jenkins environement variable. We have to detect
	# the workspace using include path.
	#
	# Legacy mode was to fetch MediaWiki core directly in the workspace hence
	# $IP is the workspace.
	# The new way is to fetch it under $WORKSPACE/src/mediawiki/core
	#
	if ( preg_match( '%(.*)/src/mediawiki/core%', $IP ) ) {
		$wgDebugLogFile = $IP . '/../../../log/mw-debug-www.log';
	} else {
		# Legacy
		$wgDebugLogFile = $IP . '/log/mw-debug-www.log';
	}
	# The resulting file has to be created by a shell script in Jenkins
	# See qunit builder macro which takes care of creation and permission
	# fixing (aka world writable)
}
