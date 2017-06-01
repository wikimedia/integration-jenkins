#!/usr/bin/env node
var devPackages, package;

devPackages = require( process.argv[ 2 ] )[ 'require-dev' ];
for ( package in devPackages ) {
	console.log( package + '=' + devPackages[ package ] );
}
