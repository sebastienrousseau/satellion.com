# SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only
"""Tests for security_txt.py. Run: python3 -m unittest discover -s scripts"""
import datetime
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import security_txt

NOW = datetime.datetime(2026, 9, 27, tzinfo=datetime.timezone.utc)
GOOD = """# satellion.com
Contact: https://github.com/sebastienrousseau/passmcp/security/advisories/new
Expires: 2027-09-27T00:00:00Z
Preferred-Languages: en
Canonical: https://satellion.com/.well-known/security.txt
Policy: https://github.com/sebastienrousseau/passmcp/security/policy
"""


class SecurityTxt(unittest.TestCase):
    # AC: CRA-05
    def test_a_complete_file_passes(self):
        self.assertEqual(security_txt.problems(GOOD, NOW), [])

    # AC: CRA-05
    def test_the_build_fails_when_expires_is_less_than_30_days_away(self):
        soon = GOOD.replace("2027-09-27T00:00:00Z", "2026-10-20T00:00:00Z")
        found = security_txt.problems(soon, NOW)
        self.assertEqual(len(found), 1)
        self.assertIn("less than 30 days", found[0])
        self.assertEqual(security_txt.problems(soon, NOW - datetime.timedelta(days=10)), [])

    # AC: CRA-05
    def test_contact_policy_canonical_and_one_expires_are_required(self):
        cases = {
            "Contact": GOOD.replace("Contact:", "X:"),
            "Policy": GOOD.replace("Policy:", "X:"),
            "Canonical": GOOD.replace("Canonical:", "X:"),
            "exactly one Expires field, has 0": GOOD.replace("Expires:", "X:"),
            "exactly one Expires field, has 2": GOOD + "Expires: 2027-01-01T00:00:00Z\n",
            "not an RFC 3339 date": GOOD.replace("2027-09-27T00:00:00Z", "next year"),
            "no time zone": GOOD.replace("2027-09-27T00:00:00Z", "2027-09-27T00:00:00"),
        }
        for want, text in cases.items():
            with self.subTest(want=want):
                self.assertIn(want, "\n".join(security_txt.problems(text + "not a field\n", NOW)))

    # AC: CRA-05
    def test_the_committed_page_generates_a_valid_file(self):
        front = (Path(__file__).parent.parent / "content" / "index.md").read_text()
        for key in ("security_contact", "security_expires", "security_policy", "security_canonical"):
            self.assertIn(f"{key}:", front)
        self.assertIn('security_policy: "https://github.com/sebastienrousseau/passmcp/security/policy"', front)


if __name__ == "__main__":
    unittest.main()
