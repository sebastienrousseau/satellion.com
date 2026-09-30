<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# 0002 — A core build that needs no passmcp release

**Status:** Accepted · **Decided:** 2026-09-28, with the first commit ·
**Recorded:** 2026-09-29

## Context

Go fetches a `satellion.com/...` module by reading a page on this site.
Before passmcp had released anything, `make site` (ADR 0001) had no release
to build against, but the module pages had to be live for Go to fetch that
first release. The site could not wait for passmcp, and passmcp could not
be installed without the site.

## Decision

The Makefile splits the build. `make core` builds everything that needs no
passmcp release: the company page, the product page with its committed
numbers, the Go module and format pages, both icon sets and security.txt.
`make site` is `core` plus what comes from a release: fresh numbers, the
manual and the sample report. `pages.yml` deploys `core` alone when passmcp
has no release tag, and `ci.yml` builds `core` on every pull request.

## Consequences

- The module paths and format URIs never depend on passmcp's release state.
- `core` needs only Python and SSG 0.0.63, so a contributor can check a
  page or layout change without Go or network access.
