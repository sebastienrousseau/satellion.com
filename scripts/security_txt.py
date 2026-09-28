# SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only
"""Check the site's security.txt (RFC 9116) before it is published.

usage: security_txt.py <path to security.txt>

The file needs a Contact, a Policy pointing at passmcp's live security
policy, a Canonical location, and exactly one Expires date at least 30 days
away. An expired security.txt must not be trusted (RFC 9116), so the build
fails a month early and renewing it is a routine change, not an outage.
The same rules are passmcp's `cra.CheckSecurityTxt` (EU Cyber Resilience Act,
CRA-05); this copy exists because the site builds against passmcp's last
release, which may predate them.
"""
import datetime
import sys
from pathlib import Path

MIN_HEADROOM = datetime.timedelta(days=30)


def problems(text, now):
    """Return what the security.txt lacks, as readable messages."""
    fields = {}
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        name, value = line.split(":", 1)
        fields.setdefault(name.strip().lower(), []).append(value.strip())
    out = [
        f"security.txt has no {name.capitalize()} field"
        for name in ("contact", "policy", "canonical")
        if not fields.get(name)
    ]
    expires = fields.get("expires", [])
    if len(expires) != 1:
        return out + [f"security.txt must have exactly one Expires field, has {len(expires)}"]
    try:
        at = datetime.datetime.fromisoformat(expires[0].replace("Z", "+00:00"))
    except ValueError:
        return out + [f"security.txt Expires is not an RFC 3339 date: {expires[0]}"]
    if at.tzinfo is None:
        return out + [f"security.txt Expires has no time zone: {expires[0]}"]
    if at - now < MIN_HEADROOM:
        out.append(f"security.txt expires {at.date()}, less than 30 days away; move security_expires on in content/index.md")
    return out


def main(argv):
    if len(argv) != 2:
        sys.exit(__doc__)
    found = problems(Path(argv[1]).read_text(), datetime.datetime.now(datetime.timezone.utc))
    for p in found:
        print(f"security_txt: {p}", file=sys.stderr)
    if found:
        sys.exit(1)
    print(f"security_txt: {argv[1]} is complete and valid for at least 30 more days")


if __name__ == "__main__":
    main(sys.argv)
