/*jshint node:true */

module.exports = function ( grunt ) {
	if ( grunt.option( 'cwd' ) ) {
		// Grunt sets cwd to directory where gruntfile is, but we need to
		// work on the Jenkins workspace instead, so navigate back there.
		// (the jenkins job passes the workspace path to --cwd)
		grunt.file.setBase( grunt.option( 'cwd' ) ) ;
	}

	grunt.task.loadTasks( __dirname + '/grunt-tasks' );
	grunt.task.loadTasks( __dirname + '/node_modules/grunt-contrib-qunit/tasks' );

	grunt.initConfig({
		qunit: {
			all: ( function () {
				var url = grunt.option( 'qunit-url' ),
					ret = {};
				if ( url ) {
					ret.options = {
						urls: [ url ],
						timeout: 30 * 1000
					};
				}
				return ret;
			}() ),
		}
	});

	grunt.registerTask( 'lint', 'jshint' );
	grunt.registerTask( 'default', 'lint' );
};
