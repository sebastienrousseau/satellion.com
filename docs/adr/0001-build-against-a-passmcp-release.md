<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# 0001 — Build the site against a passmcp release, never a branch

**Status:** Accepted · **Decided:** 2026-09-28, with the first commit ·
**Recorded:** 2026-09-29

## Context

The product page states facts about passmcp: its check count, a score, a
grade, a scoring ledger and two cited findings. The manual and the sample
report are passmcp's own. Typed by hand, those figures drift: an earlier
page showed a score out of 120 and categories passmcp never had, and kept
a check count long after passmcp had outgrown it (`scripts/site_data.py`
records both).

## Decision

`make site` clones passmcp at a release tag, by default the newest one
(`PASSMCP_REF`), runs its sample report against its fixture server, and
writes the page's numbers from that report with `scripts/site_data.py`. The
manual is built from the same checkout with MkDocs `--strict`. Pull requests
run `make check-data`, which fails when the committed page differs from what
the release produces. `pages.yml` runs daily, so a new passmcp release
reaches the site within a day without a token from passmcp's repository.

## Consequences

- A deployed page can only show numbers some passmcp release produced.
- A change to passmcp's `main` does not appear on the site until it is
  released, which is the point.
- The build needs network access to GitHub, Go and Python; `make core`
  (ADR 0002) is the build that does not.
