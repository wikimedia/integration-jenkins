<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/00_set_debug_log.php
#

if( $wgCommandLineMode ) {
	$wgDebugLogFile = getenv( 'WORKSPACE' ) . '/log/mw-debug-cli.log';
} else {
	$wgDebugLogFile = getenv( 'WORKSPACE' ) . '/log/mw-debug-www.log';
	# Make sure it is writable by Apache:
	touch( $wgDebugLogFile );
	chmod( $wgDebugLogFile, '0666' );
}
