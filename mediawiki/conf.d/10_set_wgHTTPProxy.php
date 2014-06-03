<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#

/**
 * Set $wgHTTPProxy depending on the site the code is being executed.
 *
 * References:
 * - https://bugzilla.wikimedia.org/59253
 * - https://wikitech.wikimedia.org/wiki/Http_proxy
 */
$wgHTTPProxy = call_user_func( function() {
	$proxy = 'webproxy.eqiad.wmnet:8080';
	$site_file = '/etc/wikimedia-site';
	if ( file_exists( $site_file ) ) {
		$site = rtrim(file_get_contents('/etc/wikimedia-site'));
		switch( $site ) {
			case 'pmtpa':
				$proxy = 'webproxy.pmtpa.wmnet:8080';
			break;
		}
	}

	return $proxy;
} );
