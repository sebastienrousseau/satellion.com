<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# 0003 — The site is static, and is not passmcp's application

**Status:** Accepted · **Decided:** 2026-09-28, with the first commit ·
**Recorded:** 2026-09-29

## Context

passmcp has a local web interface (`passmcp serve`). Hosting it at
satellion.com would let a visitor test a server from a browser, but a
hosted tester has to be handed a working credential for the server it
tests, and would then hold credentials for other people's systems.

## Decision

satellion.com serves static files only. It says what the tools are, how to
install them, shows a real report, and publishes the pages Go and
attestation readers resolve. It sets no cookies and runs no analytics.
`passmcp serve` runs on the operator's own machine. `ssg.toml` records this.

## Consequences

- The site holds no secrets and has no server-side attack surface;
  SECURITY.md can say so.
- Anyone who wants to test a server installs passmcp; there is no
  try-it-in-the-browser path.
