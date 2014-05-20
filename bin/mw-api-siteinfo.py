#!/usr/bin/env python
#
# Copyright (c) 2014 Antoine "hashar" Musso
# Copyright (c) 2014 Wikimedia Foundation Inc.

"""
Script to retrieve MediaWiki site information over its API
"""

EPILOG = """
NOTE: MediaWiki API fields are normalized to use underscores instead of dashes.

Examples:

    mw-api-siteinfo.py --list http://www.mediawiki.org/w/api.php
    mw-api-siteinfo.py http://www.mediawiki.org/w/api.php generator
"""

import argparse
import json
import requests

API_QUERY = {
    'action': 'query',
    'meta': 'siteinfo',
    'format': 'json',
    'siprop': 'general',
    }


#
# argparse.Namespace brings easy representation
class MwApiResponse(argparse.Namespace):
    """
    map a dict to an object
    keys containing a dash are converted to underscores
    """

    def __init__(self, **entries):
        for k, payload in entries.items():
            k = normalize(k)
            if isinstance(payload, dict):
                setattr(self, k, MwApiResponse(**payload))
            else:
                setattr(self, k, payload)


def normalize(key):
    return key.replace('-', '_')


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog=EPILOG,
        formatter_class=argparse.RawDescriptionHelpFormatter
        )
    parser.add_argument('api_url', help='MediaWiki API URL to retrieve '
                        'informations from')

    parser.add_argument(
        'fields',
        help='Fields to retrieve from query > general API result. '
             'Default: generator',
        nargs='*',
        default=['generator']
    )
    parser.add_argument(
        '--list',
        help='List available siteinfo fields',
        action='store_true'
    )

    options = parser.parse_args()
    mw_api_url = options.api_url

    response = requests.get(mw_api_url, params=API_QUERY)
    siteinfo = json.loads(response.content)
    mwresponse = MwApiResponse(**siteinfo)

    if options.list:
        normalized_keys = [normalize(k) for k in
                           mwresponse.query.general.__dict__.keys()]
        print '\n'.join(sorted(normalized_keys))
    else:
        for field in options.fields:
            print getattr(mwresponse.query.general, field)

if __name__ == '__main__':
    main()
