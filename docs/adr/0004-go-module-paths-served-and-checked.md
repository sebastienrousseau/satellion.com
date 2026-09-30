<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# 0004 — Serve the family's Go module paths, and fail the build when one breaks

**Status:** Accepted · **Decided:** 2026-09-28, with the first commit ·
**Recorded:** 2026-09-29

## Context

The family's Go modules are named `satellion.com/<repository>`, not
`github.com/...`. Go resolves such a path by fetching `https://satellion.com/<module>?go-get=1`
and reading one `go-import` meta tag. A page missing that tag, or naming
the wrong repository, breaks `go install` for every user, and nothing else
would notice.

## Decision

Every Go module in the family has a page under `content/<module>/` whose
front matter carries `go_import` and `go_source`. A nested module (its
own `go.mod` in a subdirectory) gets its own page naming the repository
root. `scripts/modules.py` lists the modules and fails `make core` when a
built page is missing, carries no tag or the wrong one, or carries more than
one. Its tests check that each committed page declares the right tag.

## Consequences

- Adding a Go module to the family means adding its page and its entry in
  `scripts/modules.py` in the same change; the tests fail otherwise.
- The module paths are part of this site's stability guarantee (README).
