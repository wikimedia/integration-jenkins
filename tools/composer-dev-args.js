#!/usr/bin/env node
var devPackages, package;

try {
	devPackages = require( process.argv[ 2 ] )[ 'require-dev' ];
	for ( package in devPackages ) {
		console.log( package + '=' + devPackages[ package ] );
	}
} catch ( e ) {
	console.error(e.message, '=> falling back to phpunit/phpunit=3.7.37');
	// Back-compat for REL1_23 which doesn't have composer.json
	console.log( 'phpunit/phpunit=3.7.37' );
}
