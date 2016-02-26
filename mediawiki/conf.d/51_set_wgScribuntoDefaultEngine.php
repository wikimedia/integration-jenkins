<?php
#
# Snippet coming from integration/jenkins.git:/mediawiki/conf.d/
#

// This gets Scribunto to run its tests such as parser tests which don't
// explicitly specify an engine to speed up any tests. Ideally Scribunto would
// auto-detect this, but for now this will significantly speeds up their
// execution – T126670
$wgScribuntoDefaultEngine = 'luasandbox';
