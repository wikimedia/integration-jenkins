<?php

class MediawikiConfdExtLoaderTest extends PHPUnit_Framework_TestCase {

	protected $tmpName = null;

	/**
	 * Create a temporary directory to be used to clone extensions to
	 */
	function setUp() {
		global $fakeExtensions;
		$fakeExtensions = array();

		$tmpName = tempnam( sys_get_temp_dir(), __CLASS__ );
		unlink( $tmpName );
		mkdir( $tmpName . "/extensions", 0777, /* recursive: */ true );
		$this->tmpName = $tmpName;

	}

	/**
	 * Remove fixture directory and child files/directories
	 */
	function tearDown() {
		$this->wfRecursiveRemoveDir( $this->tmpName );
	}

	/** Shamelessly copy pasted from MediaWiki  wfRecusriveRemoveDir() */
	protected function wfRecursiveRemoveDir( $dir ) {
		if ( is_dir( $dir ) ) {
			$objects = scandir( $dir );
			foreach ( $objects as $object ) {
				if ( $object != "." && $object != ".." ) {
					if ( filetype( $dir . '/' . $object ) == "dir" ) {
						$this->wfRecursiveRemoveDir( $dir . '/' . $object );
					} else {
						unlink( $dir . '/' . $object );
					}
				}
			}
			reset( $objects );
			rmdir( $dir );
		}
	}

	/**
	 * Simulate an extension entry point.
	 *
	 * Uses a global variable $fakeExtensions to mimic initilization of an
	 * extension. It is a basic array with key being the parameter $name, and
	 * value always set to true.  One can then assert the key exist and has a
	 * true value (@see assertLoaded()).
	 */
	protected function fakeExtension( $name ) {
		$dir = $this->tmpName . "/extensions/$name";
		mkdir( $dir, 0777, /** recursive: */ true );
		$fileHandle = fopen( $dir . "/{$name}.php", 'w+' );
		fwrite( $fileHandle, "<?php
/** Fake extension $name */
global \$fakeExtensions;
\$fakeExtensions['$name'] = true;
");
	}

	protected function createLoadFile( Array $extensions ) {
		$fileHandle = fopen( $this->tmpName . "/extensions_load.txt", 'w+' );
		fwrite( $fileHandle, implode( "\n", $extensions ) );
		fclose( $fileHandle );
	}

	/**
	 * Verify whether a fake extension has been loaded.
	 *
	 * Create the extension using fakeExtension().
	 */
	protected function assertLoaded( $name ) {
		global $fakeExtensions;
		$this->assertArrayHasKey( $name, $fakeExtensions,
			"Extension $name did not get loaded"
		);
	}

	/**
	 * Verify whether a fake extension has NOT been loaded.
	 *
	 * Create the extension using fakeExtension().
	 */
	protected function assertNotLoaded( $name ) {
		global $fakeExtensions;
		$this->assertArrayNotHasKey( $name, $fakeExtensions,
			"Extension $name has been loaded"
		);
	}

	protected function runLoader() {
		global $IP;
		$IP = $this->tmpName;
		require( __DIR__ . '/../../../mediawiki/conf.d/50_mw_ext_loader.php' );
	}

	function testLoadNothing() {
		global $fakeExtensions;
		$this->runLoader();
		$this->assertEquals( array(), $fakeExtensions );
	}

	function testLoadAnExtension() {
		$this->fakeExtension( 'Foobar' );
		$this->runLoader();
		$this->assertLoaded( 'Foobar' );
	}

	function testLoadTwoExtensions() {
		$this->fakeExtension( 'ExtOne' );
		$this->fakeExtension( 'ExtTwo' );
		$this->runLoader();
		$this->assertLoaded( 'ExtOne' );
		$this->assertLoaded( 'ExtTwo' );
	}

	function testOnlyLoadFromFile() {
		$this->fakeExtension( 'Must_not_be_loaded' );
		$this->createLoadFile( array() );
		$this->runLoader();
		$this->assertNotLoaded( 'Must_not_be_loaded' );
	}

	function testLoadFromFile() {
		$this->fakeExtension( 'LoadedFromFile' );
		$this->createLoadFile( array( 'LoadedFromFile' ) );
		$this->runLoader();
		$this->assertNotLoaded( 'Must_not_be_loaded' );
		$this->assertLoaded( 'LoadedFromFile' );
	}

	function testLoadFromFileWithMultipleEntries() {
		$this->fakeExtension( 'FirstExt' );
		$this->fakeExtension( 'SecondExt' );
		$this->createLoadFile( array(
			'FirstExt',
			'SecondExt',
		) );
		$this->runLoader();
		$this->assertLoaded( 'FirstExt' );
		$this->assertLoaded( 'SecondExt' );
	}

	function testLoadFromFileWithGerritNames() {
		$this->fakeExtension( 'Must_not_be_loaded' );
		$this->fakeExtension( 'BaseName' );
		$this->fakeExtension( 'GerritRepoName' );
		$this->createLoadFile( array(
			'mediawiki/extensions/GerritRepoName',
			'BaseName',
		) );
		$this->runLoader();
		$this->assertNotLoaded( 'Must_not_be_loaded' );
		$this->assertLoaded( 'GerritRepoName' );
	}

	function testLoadFromFileWithEmptyLines() {
		$this->fakeExtension( 'One' );
		$this->createLoadFile( array( 'One', "\n" ) );
		$this->runLoader();
		$this->assertLoaded( 'One' );
	}

}
