<?php
$func_get_exts = function () {
	global $IP;
	if( !is_dir( $IP ) ) {
		echo "Invalid MediaWiki path '$IP'.\n";
		echo "Aborting\n";
		exit(1);
	}
	$ext_to_load = array();
	$ext_missing = array();
	foreach( scandir("{$IP}/extensions/") as $extname ) {
		if( $extname == '.'
			|| $extname == '..'
			|| !is_dir( "{$IP}/extensions/${extname}" )
		) {
			continue;
		}
		$extfile = "{$IP}/extensions/{$extname}/{$extname}.php";
		if( file_exists($extfile) ) {
			$ext_to_load[] = $extfile;
		} else {
			$ext_missing[] = $extfile;
		}
	}
	if( count($ext_missing) ) {
		echo "Could not load some extensions because they are missing\n";
		echo "the expected entry point:\n\n";
		echo implode( "\n", $ext_missing );
		echo "\n\nAborting\n";
		exit(1);
	}
	return $ext_to_load;
};

foreach( $func_get_exts() as $extname ) {
	require_once( $extname );
}
