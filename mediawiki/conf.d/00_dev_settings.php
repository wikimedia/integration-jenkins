<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
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

// Debugging: PHP
error_reporting( -1 );
ini_set( 'display_errors', 1 );

// Debugging: MediaWiki
$wgDevelopmentWarnings = true;
$wgShowDBErrorBacktrace = true;
$wgShowExceptionDetails = true;
$wgShowSQLErrors = true;
$wgDebugRawPage = true; // bug 47960

// Debugging: Logging
if ( $wgCommandLineMode ) {
	$wgDebugLogFile = "$wmgMwLogDir/mw-debug-cli.log";
} else {
	$wgDebugLogFile = "$wmgMwLogDir/mw-debug-www.log";
}
$wgDebugTimestamps = true;
$wgDBerrorLog = "$wmgMwLogDir/mw-dberror.log";
$wgDebugLogGroups['ratelimit'] = "$wmgMwLogDir/mw-ratelimit.log";
$wgDebugLogGroups['exception'] = "$wmgMwLogDir/mw-exception.log";
$wgDebugLogGroups['error'] = "$wmgMwLogDir/mw-error.log";
// Back-compat
$wgRateLimitLog = $wgDebugLogGroups['ratelimit'];
