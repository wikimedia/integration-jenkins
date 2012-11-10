<?php

require_once( "$IP/extensions/cldr/cldr.php" );
require_once( "$IP/extensions/UniversalLanguageSelector/UniversalLanguageSelector.php" );

require_once( "$IP/extensions/Diff/Diff.php");

require_once( "$IP/extensions/Wikibase/lib/WikibaseLib.php");
require_once( "$IP/extensions/Wikibase/repo/Wikibase.php");

$baseNs = 100;

// Define the namespace indexes
define( 'WB_NS_PROPERTY', $baseNs );
define( 'WB_NS_PROPERTY_TALK', $baseNs + 1 );
define( 'WB_NS_QUERY', $baseNs + 2 );
define( 'WB_NS_QUERY_TALK', $baseNs + 3 );

// Define the namespaces
$wgExtraNamespaces[WB_NS_PROPERTY] = 'Property';
$wgExtraNamespaces[WB_NS_PROPERTY_TALK] = 'Property_talk';
$wgExtraNamespaces[WB_NS_QUERY] = 'Query';
$wgExtraNamespaces[WB_NS_QUERY_TALK] = 'Query_talk';

// Assigning the correct content models to the namespaces
$wgWBSettings['entityNamespaces'][CONTENT_MODEL_WIKIBASE_ITEM] = NS_MAIN;
$wgWBSettings['entityNamespaces'][CONTENT_MODEL_WIKIBASE_PROPERTY] =
WB_NS_PROPERTY;
$wgWBSettings['entityNamespaces'][CONTENT_MODEL_WIKIBASE_QUERY] = WB_NS_QUERY;

$wgWBSettings['idBlacklist'] = array( 1, 2, 3, 4, 5, 8, 13, 23, 24,
42, 80, 666, 1337, 1868, 1971, 2000, 2001, 2012, 2013 );
