<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#

// Production CI slaves have tmpfs under Jenkins home, use it!
$jenkinsUserHome = getenv('HOME') ?: '/var/lib/jenkins-slave';
$jenkinsTmpFs = "{$jenkinsUserHome}/tmpfs";
$jenkinsJobName = getenv( 'JOB_NAME' );
if ( $jenkinsJobName && is_dir( "$jenkinsTmpFs/$jenkinsJobName" ) ) {
	    $wgTmpDirectory = "$jenkinsTmpFs/$jenkinsJobName";
}
