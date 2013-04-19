<?php

// Debugging: PHP
error_reporting( -1 );
ini_set( 'display_errors', 1 );

// Debugging: MediaWiki
$wgDevelopmentWarnings = true;
$wgShowExceptionDetails = true;

// gallium.wikimedia.org has tmpfs installed, use that instead of
// the default /tmp.
$jenkinsTmpFs = '/var/lib/jenkins/tmpfs';
$jenkinsJobName = getenv( 'JOB_NAME' );
if ( $jenkinsJobName && is_dir( "$jenkinsTmpFs/$jenkinsJobName" ) ) {
	$wgTmpDirectory = "$jenkinsTmpFs/$jenkinsJobName";
}
