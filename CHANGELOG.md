<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# Changelog

All notable changes to satellion.com are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions move by
0.0.1 a release, as across the passmcp family.

## [0.0.2]

### Added

- **Go module pages for `satellion.com/passmcp-lsp` and
  `satellion.com/passmcp-census`**, checked by `scripts/modules.py` like the
  others.
- **The whole family on the site.** The company page and passmcp's page list
  all nine components with their release status, and the components the
  family considered and rejected with the reason, rendered by
  `scripts/family.py` (`make family`) from passmcp's `ecosystem.json`. It
  reads both manifest schemas: schema 2's `repository` field and
  `released`/`unreleased`/`rejected` statuses, and schema 1's
  `shipping`/`planned`. passmcp's page shows that discovery, the graph and
  the compliance mappings were released in passmcp 0.0.1 rather than as
  planned work.
- **A coverage badge.** `make coverage` runs the scripts' tests under
  coverage.py, gated at 85%, and the deploy publishes
  `https://satellion.com/coverage.json`.
- **The family's standard files and gates:** `ci.yml`, `docs-lint.yml`
  (REUSE, markdownlint, codespell, links), OpenSSF Scorecard, DCO and PR-base
  workflows; `scripts/verify-release-versions.sh`; AGENTS.md, DEVELOPMENT.md,
  GOVERNANCE.md, SUPPORT.md, docs/ARCHITECTURE.md and ADRs; issue and pull
  request templates, CODEOWNERS, `.editorconfig`, `.gitattributes`,
  `.codespellrc` and a pre-commit configuration.
- Tests for `scripts/site_data.py` and `scripts/cards.py`, and a complexity
  gate (`make complexity`) at cyclomatic 10 and cognitive 15 per function.

### Changed

- `scripts/site_data.py` and `scripts/security_txt.py` are split into
  smaller functions to meet those ceilings; their output is unchanged.
- The README's badges, ecosystem table and statuses follow the family
  standard.

### Removed

- The "Planned" roadmap section of passmcp's page: all three items it
  listed were released in passmcp 0.0.1.

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
