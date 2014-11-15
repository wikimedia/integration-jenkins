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
$wgHTTPProxy = call_user_func( function () {
	$site_file = '/etc/wikimedia-site';
	$site = file_exists( $site_file )
		? rtrim( file_get_contents( $site_file ) )
		: 'eqiad';

	switch ( $site ) {
		case 'eqiad':
		default:
			$proxy = 'webproxy.eqiad.wmnet:8080';
	}

	return $proxy;
} );
