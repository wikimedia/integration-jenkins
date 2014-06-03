<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/00_set_debug_log.php
#

// Under Apache, there is no Jenkins environement variable. We have to detect
// the workspace using MediaWiki's include path.
//
// Legacy mode was to fetch MediaWiki core directly in the workspace hence
// $IP is the workspace.
// The new way is to fetch it under $WORKSPACE/src/mediawiki/core
if ( $wgCommandLineMode ) {
	$wmgJobWorkspace = getenv( 'WORKSPACE' );
} elseif ( preg_match( '%(.*)/src/mediawiki/core%', $IP ) ) {
	$wmgJobWorkspace = $IP . '/../../..';
} elseif ( preg_match( '%(.*)/src%', $IP ) ) {
	$wmgJobWorkspace = $IP . '/..';
} else {
	$wmgJobWorkspace = $IP;
}

$wmgMwLogDir = "$wmgJobWorkspace/log";

$wgDBerrorLog = "$wmgMwLogDir/mw-dberror.log";
$wgRateLimitLog = "$wmgMwLogDir/mw-ratelimit.log";

if ( $wgCommandLineMode ) {
	$wgDebugLogFile = "$wmgMwLogDir/mw-debug-cli.log";
} else {
	$wgDebugLogFile = "$wmgMwLogDir/mw-debug-www.log";
}
