<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/00_set_debug_log.php
#

if( $wgCommandLineMode ) {
	$wgDebugLogFile = getenv( 'WORKSPACE' ) . '/log/mw-debug-cli.log';
} else {
	# Under Apache, there is no Jenkins environnement variable. Since MediaWiki
	# include path is the workspace, use $IP instead.
	$wgDebugLogFile = $IP . '/log/mw-debug-www.log';
	# The resulting file has to be created by a shell script in Jenkins
	# See qunit builder macro which takes care of creation and permission
	# fixing (aka world writable)
}
