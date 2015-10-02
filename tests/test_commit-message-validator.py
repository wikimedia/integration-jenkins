#!/usr/bin/env python

import imp
import os
import sys
import unittest

if sys.version_info[0] > 2:
    from io import StringIO
else:
    from StringIO import StringIO

cmv = imp.load_source(
    'cmv',
    os.path.dirname(os.path.dirname(__file__)) +
    '/tools/commit-message-validator.py')


class MetaValidator(type):

    """
    Create test class which checks the output for a message.

    It searches through `tests/test_commit-message-validator/` and loads all
    file pairs where there is a `.msg` and `.out` file. If both exist it'll
    create a test for this pair where the `.msg` is the commit message and the
    `.out` is the expected output.
    """

    def __new__(cls, name, bases, dct):
        def create_test_method(msg, expected):
            def test(self):
                saved_stdout = sys.stdout
                try:
                    out = StringIO()
                    sys.stdout = out
                    self.assertEqual(
                        1 if expected else 0,
                        cmv.check_message(msg.splitlines()))
                    self.assertEqual(expected, out.getvalue())
                finally:
                    sys.stdout = saved_stdout
            return test

        base_path = os.path.join(os.path.dirname(__file__),
                                 'test_commit-message-validator')
        for fn in os.listdir(base_path):
            test, _, extension = fn.rpartition('.')
            fn = os.path.join(base_path, test)
            if extension == 'msg' and os.path.isfile(fn + '.out'):
                with open(fn + '.msg') as msg:
                    with open(fn + '.out') as out:
                        dct['test_' + test] = create_test_method(
                            msg.read(), out.read())
        return super(MetaValidator, cls).__new__(cls, name, bases, dct)


class TestCommitMessageValidator(unittest.TestCase):

    """Validate the commit messages using test files."""

    __metaclass__ = MetaValidator
