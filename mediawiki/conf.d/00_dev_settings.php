<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#

// Debugging: PHP
error_reporting( -1 );
ini_set( 'display_errors', 1 );

// Debugging: MediaWiki
$wgDevelopmentWarnings = true;
$wgShowDBErrorBacktrace = true;
$wgShowExceptionDetails = true;
$wgShowSQLErrors = true;
$wgDebugRawPage = true; // bug 47960
