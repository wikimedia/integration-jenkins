/*jshint node:true */

module.exports = function ( grunt ) {
	if ( grunt.option( 'cwd' ) ) {
		// Grunt sets cwd to directory where gruntfile is, but we need to
		// work on the Jenkins workspace instead, so navigate back there.
		// (the jenkins job passes the workspace path to --cwd)
		grunt.file.setBase( grunt.option( 'cwd' ) ) ;
	}

	grunt.task.loadTasks( __dirname + '/../../tools/grunt-tasks' );
	grunt.task.loadTasks( __dirname + '/../../tools/node_modules/grunt-contrib-qunit/tasks' );
	grunt.task.loadTasks( __dirname + '/../../tools/node_modules/grunt-contrib-csslint/tasks' );

	grunt.initConfig({
		qunit: {
			all: ( function () {
				var url = grunt.option( 'qunit-url' ),
					file = grunt.option( 'qunit-file' ),
					ret = {};
				if ( url ) {
					ret.options = {
						urls: [ url ],
						timeout: 30 * 1000
					};
				}
				if ( file ) {
					ret.src = [ file ];
				}
				return ret;
			}() ),
		},
		csslint: {
			options: {
				csslintrc: '.csslintrc'
			},
			all: ( function () {
				var patterns = [ '**/*.css' ];
				if ( grunt.file.exists( '.csslintignore' ) ) {
					grunt.file.read( '.csslintignore' ).split( '\n' ).forEach( function ( pattern ) {
						// Filter out empty lines
						pattern = pattern.trim();
						if ( pattern ) {
							patterns.push( '!' + pattern.trim() );
						}
					} );
				}
				return patterns;
			}() )
		}
	});

	// Alias for sequence of lint tasks, later this will include phplint, csslint etc.
	grunt.registerTask( 'lint', 'jshint' );

	grunt.registerTask( 'default', 'lint' );
};
