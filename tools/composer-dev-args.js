#!/usr/bin/env node
var devPackages = require( process.argv[ 2 ] )[ 'require-dev' ],
	package;

for ( package in devPackages ) {
	console.log( package + '=' + devPackages[ package ] );
}
