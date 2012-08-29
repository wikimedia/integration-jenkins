<?php
# Lame script to import any extension available under $IP/extensions
# This is used by Jenkins to easily bootstrap extensions

if( !defined( 'MEDIAWIKI' ) || !$IP ) {
	die( __FILE__ . " is not a valid entry point\n" );
}

foreach( scandir( "$IP/extensions" ) as $name ) {
	$dir = "$IP/extensions/$name";

	# Skip non directory and 'hidden' files such as '.' and '..'
	if( !is_dir( $dir ) || strpos($name, '.') === 0) {
		continue;
	}

	#### EXCEPTIONS ###################################################
	if( $name == 'Wikibase' ) {
		# Wikibase extension does not respect the usual conventions
		# we load it using the job ExtraSettings.php
		continue;
	}


	# Blindly require extension entry file
	#
	# require_once() is used to easily detect extension not respecting
	# the default convention. That will throw out a fatal error under
	# Jenkins.
	require_once( "$dir/$name.php" );
}
