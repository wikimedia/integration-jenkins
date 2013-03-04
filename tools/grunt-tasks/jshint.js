module.exports = function ( grunt ) {

	//grunt.loadNpmTasks( 'grunt-contrib-jshint' ); // Doesn't support .jshintignore yet
	grunt.registerTask( 'jshint', function () {
		var done = this.async();
		grunt.util.spawn({
			cmd: __dirname + '/../node_modules/.bin/jshint', args: [ '.' ]
		}, function ( err, results ) {
			if ( err ) {
				grunt.log.error( results.stdout );
				done( false );
			} else {
			    grunt.log.ok();
				done();
			}
		});

	} );
};
