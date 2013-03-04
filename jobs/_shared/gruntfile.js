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

	grunt.initConfig({
		qunit: {
			all: {
				options: {
					urls: [
						grunt.option( 'qunit-url' ) || 'http://localhost/wiki/Special:JavaScriptTest/qunit'
					],
					timeout: 30 * 1000
				}
			}
		}
	});

	// Alias for sequence of lint tasks, later this will include phplint, csslint etc.
	grunt.registerTask( 'lint', 'jshint' );

	grunt.registerTask( 'default', 'lint' );
};
