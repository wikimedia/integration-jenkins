<?php
#
# Snippet coming from integration/jenkins.git
# mediawiki.d/10_set_wgWikimediaJenkinsCI.php
#

# inject $wgWikimediaJenkinsCI = true
#
# That is an horrrrible hack to let extensions (such as Wikibase) behave
# differently when being run on Wikimedia Jenkins CI.  That is more or less
# needed when running Wikibase under Apache for QUnit, since the Jenkins
# environnement variables are not available to the Apache process, the Wikibase
# entry point had no real way to detect where it was running (currently uses
# JOB_NAME env variable, which is not set).

$wgWikimediaJenkinsCI = true;
