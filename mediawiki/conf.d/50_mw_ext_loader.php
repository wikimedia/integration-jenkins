<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#

$func_get_exts = function () {
	global $IP;

	if ( !is_dir( $IP ) ) {
		echo "Invalid MediaWiki path '$IP'.\n";
		echo "Aborting\n";
		exit(1);
	}

	// Get the current project
	$ZUUL_PROJECT = getenv( 'ZUUL_PROJECT' );

	// Attempt to extract the extension name
	$currentExt = null;
	$m = array();
	if ( preg_match_all(
		'%^mediawiki/extensions/(.*)$%',
		$ZUUL_PROJECT,
		$m
	) ) {
		$currentExt = $m[1][0];
	}

	$ext_to_load = array();
	$ext_missing = array();
	foreach ( scandir( "{$IP}/extensions/" ) as $extname ) {
		if ( $extname == '.'
			|| $extname == '..'
			|| !is_dir( "{$IP}/extensions/${extname}" )
		) {
			continue;
		}

		// Bug 42960: Ignore empty extensions
		$hasContent = array_diff(
			scandir( "{$IP}/extensions/${extname}" ),
			array( '.', '..' )
		);
		if( !$hasContent ) {
			continue;
		}

		$extfile = "{$IP}/extensions/{$extname}/{$extname}.php";
		if( file_exists( $extfile ) ) {
			$ext_to_load[$extname] = $extfile;
		} else {
			$ext_missing[] = $extfile;
		}
	}
	if ( count( $ext_missing ) ) {
		echo "Could not load some extensions because they are missing\n";
		echo "the expected entry point:\n\n";
		echo implode( "\n", $ext_missing );
		echo "\n\nAborting\n";
		exit(1);
	}

	// Make sure the current extension is loaded last
	if ( $currentExt ) {
		$currentExtFile = $ext_to_load[$currentExt];
		unset( $ext_to_load[$currentExt] );
		$ext_to_load[$currentExt] = $currentExtFile;
	}

	return $ext_to_load;
};

foreach ( $func_get_exts() as $extname ) {
	require_once $extname;
}
