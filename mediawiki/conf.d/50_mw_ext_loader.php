<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#
# Loads extensions using either:
# - a list of extension names in /extensions_load.txt . They can be either the
#   name of the Gerrit repository (mediawiki/extensions/Foobar) or the basename
#   (Foobar).
# - a scan of the directory /extensions/
#
# It will then load the default entry point: /Foo/Foo.php

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
	$ext_candidates = array();

	$loadFile = $IP . '/extensions_load.txt';
	if ( file_exists( $loadFile ) ) {
		$ext_candidates = file( $loadFile,
			FILE_IGNORE_NEW_LINES
			| FILE_SKIP_EMPTY_LINES
		);
		$ext_candidates = array_map( function ( $entry ) {
			return str_replace( 'mediawiki/extensions/', '', $entry );
		}, $ext_candidates );
	} else {
		$ext_candidates = scandir( "${IP}/extensions/" );
	}

	foreach ( $ext_candidates as $extname ) {
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

	return $ext_to_load;
};

foreach ( $func_get_exts() as $extname ) {
	require_once $extname;
}
