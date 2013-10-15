<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/00_dev_settings.php
#

// Debugging: PHP
error_reporting( -1 );
ini_set( 'display_errors', 1 );

// Debugging: MediaWiki
$wgDevelopmentWarnings = true;
$wgShowExceptionDetails = true;
