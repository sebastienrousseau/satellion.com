<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# Changelog

All notable changes to satellion.com are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions move by
0.0.1 a release, as across the passmcp family.

## [0.0.1] — 2026-09-29

The first release.

### Added

- **Satellion's home** at `/`, in the logo's own palette, with light and
  dark themes.
- **passmcp's page** at `/passmcp/`, its manual at `/passmcp/docs/` and a real
  sample report at `/passmcp/sample/`, all built from passmcp's release.
- **Go module pages** for `satellion.com/passmcp` and its four sibling
  modules, checked on every build by `scripts/modules.py`.
- **Format pages** for the attestation and graph format URIs.
- **A security.txt** at `/.well-known/security.txt` (RFC 9116) that fails the
  build before it can expire.
- **Social cards** rendered from `cards/` by `scripts/cards.py`.
- **Two builds:** `make core` needs no passmcp release, and `make site` adds
  what comes from one.
