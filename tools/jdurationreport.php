<?php
# Joint copyright:
# Copyright © 2012, Wikimedia Foundation
# Copyright © 2012, Antoine "hashar" Musso

# Very basic tool to dump the duration of builds
# for the MediaWiki-GIT-Fetching job.

namespace Wikimedia;

define( 'JENKINS_HOME', '/var/lib/jenkins' );
define( 'JENKINS_JOBS', JENKINS_HOME . '/jobs' );

class Jenkins {

	/** Time format used by Jenkins to create the builds directories */
	private static $buildDateFormat = "Y-m-d_H-i-s";

	/**
	 * Returns an array of job names.
	 * Result is cached.
	 */
	public static function getJobs() {
		static $jobslist = null;  # cache
		if( is_null($jobslist) ) {
			$jobslist = self::getSubDirs(JENKINS_JOBS);
		}
		return $jobslist;
	}

	/**
	 * Result is cached per job
	 */
	public static function getBuildsFilenames( $job ) {
		static $cache = array();
		if(!array_key_exists($job, $cache)) {
			$cache[$job] = self::getSubDirs(JENKINS_JOBS . "/$job/builds");
		}
		return $cache[$job];
	}

	/**
	 * Return name of directories under $dir directory
	 */
	private static function getSubDirs( $dir ) {
		$files = array();
		$dir = new \DirectoryIterator($dir);
		foreach ($dir as $fileinfo) {
			# Filter unwanted files
			if(     $fileinfo->isDot()
			    || !$fileinfo->isDir()
			    ||  $fileinfo->isLink()
			) {
				continue;
			}
			$files[] = $fileinfo->getFilename();
		}
		sort($files);
		return $files;
	}

	public static function dateFromBuild($buildname) {
		return \DateTime::createFromFormat(
			self::$buildDateFormat,
			$buildname
		);

	}

}

$j = new Jenkins();

$stats = array();
foreach( $j->getBuildsFilenames('MediaWiki-GIT-Fetching') as $buildname) {

	$buildfile = JENKINS_JOBS.'/MediaWiki-GIT-Fetching/builds/'
		. $buildname . '/build.xml';
	if(!file_exists($buildfile)){
		continue;
	}
	$xml = file_get_contents($buildfile);

	if( preg_match_all( '%<duration>(\d+)</duration>%m', $xml, $m) ) {
		$stats[$buildname]=(int)$m[1][0];
	};
}

foreach($stats as $buildname => $duration) {
	$duration = $duration/1000;
	print "$buildname took {$duration} s.\n";
}


