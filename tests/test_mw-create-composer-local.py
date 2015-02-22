#!/usr/bin/env python

import imp
import os
import tempfile
import unittest
path = os.path.dirname(os.path.dirname(__file__)) \
    + '/bin/mw-create-composer-local.py'
mw_create_composer_local = imp.load_source('mw-create-composer-local', path)


class TestMwCreateComposerLocal(unittest.TestCase):
    def test_main(self):
        _, el_path = tempfile.mkstemp()
        with open(el_path, 'w') as f:
            f.write("""
mediawiki/extensions/FooBar
mediawiki/extensions/BarFoo

mediawiki/extensions/BazFoo
    """.strip())
        _, clocal_path = tempfile.mkstemp()
        mw_create_composer_local.main(el_path, clocal_path)
        self.assertEqual(
            open(clocal_path).read(),
            '{"extra": {"merge-plugin": {"include": ["extensions/FooBar/compos'
            'er.json", "extensions/BarFoo/composer.json", "extensions/BazFoo/c'
            'omposer.json"]}}}'
        )
        os.unlink(clocal_path)
