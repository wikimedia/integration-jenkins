#!/usr/bin/env php
<?php
/**
* Recursive JSON linter.
*
* Copyright © 2014, Antoine "hashar" Musso
* Copyright © 2014, Wikimedia Foundaction Inc.
*
* Licensed under the GPLv2.
*/

$paths = array_slice( $argv, 1 );
if ( count( $paths ) === 0 ) {
	print <<<EOF
PHP based json linter

Usage: $argv[0] [path [path] [...]]]

EOF;
}

/**
 * Whether $file content can be decoded by json_decode().
 *
 * @param String $content JSON payload to decode
 * @return Boolean Whether json_decode() managed to decode JSON.
 */
function lint_json_file( $file ) {
	$content = file_get_contents( $file );
	return null !== json_decode( $content );
}

# Reimplements json_last_error_msg() messages from PHP 5.5.8
if ( !function_exists( 'json_last_error_msg' ) ) {
	function json_last_error_msg() {
		switch( json_last_error() ) {
			case JSON_ERROR_NONE:
				$msg = 'No error';
			break;
			case JSON_ERROR_DEPTH:
				$msg = 'Maximum stack depth exceeded';
			break;
			case JSON_ERROR_STATE_MISMATCH:
				$msg = 'State mismatch (invalid or malformed JSON)';
			break;
			case JSON_ERROR_CTRL_CHAR:
				$msg = 'Control character error, possibly incorrectly encoded';
			break;
			case JSON_ERROR_SYNTAX:
				$msg = 'Syntax error';
			break;
			case JSON_ERROR_UTF8:
				$msg = 'Malformed UTF-8 characters, possibly incorrectly encoded';
			break;
			# Other cases were introduced in PHP 5.5.0 which has json_last_error_msg()
			default:
				$msg = 'Unknown error';
		}
		return $msg;
	}  # end of json_last_error_msg()
}

$exitCode = 0;
foreach( $paths as $path ) {
	# Find json files and normalizes them to an iterator of SplFileInfo
	if( !is_dir( $path ) ) {
		$jsonFiles = array( new SplFileInfo( $path ) );
	} else {  // Directory
		$iter = new RecursiveIteratorIterator(
			new RecursiveDirectoryIterator( $path,
				FilesystemIterator::CURRENT_AS_FILEINFO
			)
		);
		$jsonFiles = new RegexIterator( $iter, '/\.json$/' );
	}

	foreach ( $jsonFiles as $file ) {
		$result = lint_json_file( $file->getPathname() );
		if ( ! $result ) {
			$exitCode = 1;
			fwrite(STDERR, $file->getPathname() . ": json decode error.\n" );
		}
	}
}
exit($exitCode);
