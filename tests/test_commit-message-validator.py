#!/usr/bin/env python

import imp
import os
import unittest

cmv = imp.load_source(
    'cmv',
    os.path.dirname(os.path.dirname(__file__)) +
    '/tools/commit-message-validator.py')


class TestCommitMessageValidator(unittest.TestCase):
    def test_check_message_errors(self):
        path = os.path.dirname(__file__) + '/test_commit-message-validator/'
        with open(path + 'check_message_errors.msg') as msg:
            with open(path + 'check_message_errors.out') as out:
                self._test_check_message(msg.read(), 1, out.read())

    def test_check_message_ok(self):
        path = os.path.dirname(__file__) + '/test_commit-message-validator/'
        with open(path + 'check_message_ok.msg') as msg:
            with open(path + 'check_message_ok.out') as out:
                self._test_check_message(msg.read(), 0, out.read())

    def _test_check_message(self, msg, expect_status, expect_out):
        import sys
        import StringIO
        saved_stdout = sys.stdout
        try:
            out = StringIO.StringIO()
            sys.stdout = out
            self.assertEqual(
                expect_status,
                cmv.check_message(msg.splitlines()))
            self.assertEqual(expect_out, out.getvalue())
        finally:
            sys.stdout = saved_stdout
