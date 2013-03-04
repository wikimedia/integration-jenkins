module.exports = function ( grunt ) {
	grunt.registerTask( 'phplint', function ( filter ) {
		var pattern = '**/*.{php,inc,php5,phtml}',
			done = this.async();

		grunt.util.async.parallel({
			files: function ( callback ) {
				if ( filter === 'head' ) {
					grunt.util.spawn({ cmd: 'git', args: ['diff', 'HEAD^1', 'HEAD', '--name-only'] },
					function ( err, response ) {
						callback( null, grunt.file.match( pattern, response.stdout.split( '\n' ) ) );
					});
				} else {
					callback( null, grunt.file.expandFiles( pattern ) );
				}
			}
		}, function ( err, results ) {
			var fails = [];
			if ( err ) {
				grunt.log.error( err );
				return done( false );
			}
			grunt.util.async.forEachSeries( results.files, function ( item, callback ) {
				grunt.util.spawn({ cmd: 'php', args: ['-l', item] },
				function ( err, response ) {
					if ( err ) {
						grunt.log.write( 'F'.red.bold );
						fails.push( response.stdout );
					} else {
						grunt.log.write( '.' );
					}
					callback();
				} );
			}, function () {
				grunt.log.write('\n');
				if ( fails.length ) {
					grunt.log.error( fails.length + ' files contained errors:\n' + fails.join( '\n' ) );
					done( false );
				} else {
					done();
				}
			});
		});
	} );
};
