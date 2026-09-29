<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

<p align="center">
  <img src="https://raw.githubusercontent.com/sebastienrousseau/satellion.github.io/main/brand/satellion/logo.svg" alt="Satellion logo" width="180" />
</p>

<h1 align="center">satellion.com</h1>

<p align="center">
  The source of <a href="https://satellion.com/">satellion.com</a>: Satellion's home, passmcp's pages, and the pages Go and attestation readers resolve, built with SSG.
</p>

<p align="center">
  <a href="https://github.com/sebastienrousseau/satellion.github.io/actions"><img src="https://img.shields.io/github/actions/workflow/status/sebastienrousseau/satellion.github.io/pages.yml?style=for-the-badge&logo=github" alt="Build" /></a>
  <a href="https://satellion.com/"><img src="https://img.shields.io/badge/site-satellion.com-214186?style=for-the-badge" alt="Site" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=for-the-badge" alt="License: GPL-3.0-only" /></a>
</p>

---

## Contents

**Getting started**

- [Install](#install) — the tools the build needs
- [Requirements](#requirements) — Go, Python, SSG 0.0.63
- [Quick Start](#quick-start) — build and serve the site locally, with or without a passmcp release

**The satellion.com ecosystem**

- [The satellion.com ecosystem](#the-satellioncom-ecosystem) — where the site's content comes from

**Library reference**

- [Capabilities at a glance](#capabilities-at-a-glance) — what the build produces
- [Ecosystem comparison](#ecosystem-comparison) — not applicable
- [Benchmarks](#benchmarks) — not applicable
- [Features](#features) — what keeps the pages accurate
- [Configuration](#configuration) — `ssg.toml` and the Makefile variables
- [Examples](#examples) — building against a given release

**Operational**

- [When not to use satellion.com](#when-not-to-use-satellioncom) — limits
- [Development](#development) — make targets, CI
- [Security](#security) — reporting
- [Documentation](#documentation) — where the docs live
- [Stability guarantees](#stability-guarantees) — the URLs other systems rely on
- [License](#license)

---

## Install

```sh
cargo install ssg --locked --version 0.0.63
git clone https://github.com/sebastienrousseau/satellion.github.io
```

---

## Requirements

`make core` needs only Python 3.12 or later and SSG 0.0.63. `make site`
also needs Go (stable), git and network access to GitHub: it clones passmcp
at its latest release tag, builds it, and installs the manual's hash-locked
requirements into a local virtual environment under `.build/`.

---

## Quick Start

```sh
make core     # the pages that need no passmcp release
make site     # core, plus the manual and sample report from the latest release
make serve    # then open http://localhost:8000
```

---

## The satellion.com ecosystem

The product pages are assembled from passmcp's own artefacts at a release,
so nothing on them is typed twice.

| Component | Purpose | Use case |
| :--- | :--- | :--- |
| [passmcp](https://github.com/sebastienrousseau/passmcp) | The engine; its `docs/` become `/passmcp/docs/`, its sample report `/passmcp/sample/` | Everything the site describes |
| [passmcp-reporting](https://github.com/sebastienrousseau/passmcp-reporting) | The Apache-2.0 attestation verifier | The "Verify" section |
| [passmcp-action](https://github.com/sebastienrousseau/passmcp-action) | GitHub Action and GitLab template | Integrations |
| [passmcp-server](https://github.com/sebastienrousseau/passmcp-server) | passmcp as MCP tools, in the MCP Registry | Integrations |

---

## Capabilities at a glance

| Area | Capability | Status |
| :--- | :--- | :--- |
| Company page | Satellion's home, from `content/index.md` and the `company` layout | Stable |
| Product page | passmcp's page at `/passmcp/`, from `content/passmcp/index.md` | Stable |
| Go module pages | `satellion.com/passmcp` and its four sibling modules resolve to their repositories | Stable |
| Format pages | The attestation and graph format URIs resolve to their specifications | Stable |
| Numbers | Score, grade, counts, ledger, phases and evidence from passmcp's sample report | Stable |
| Manual | passmcp's `docs/`, built with MkDocs `--strict`, at `/passmcp/docs/` | Stable |
| Sample | passmcp's real report against its fixture server, at `/passmcp/sample/` | Stable |
| Social cards | Rendered from `cards/` by `scripts/cards.py` | Stable |

---

## Ecosystem comparison

Not applicable: this repository is a website, not a library. How passmcp
compares with other tools is on the site itself, with sources.

---

## Benchmarks

Not applicable: the site is static. passmcp's benchmarks are in its
[manual](https://satellion.com/passmcp/docs/BENCHMARKS/).

---

## Features

- **Numbers that cannot drift.** `scripts/site_data.py` writes every check
  count and the sample's numbers from passmcp's release on every build, and
  pull requests fail if the committed pages differ.
- **Module paths that cannot break quietly.** `scripts/modules.py` fails the
  build if any Go module page lacks its `go-import` tag or names the wrong
  repository.
- **A security.txt that cannot lapse.** The build fails when its Expires date
  is under 30 days away.
- **Built against a release, not a branch.** The Makefile resolves passmcp's
  newest tag; a daily build keeps the site on it.

---

## Configuration

`ssg.toml` sets the site name, base URL and directories. The Makefile takes
`PASSMCP_REF` (a passmcp tag, default the latest), `PASSMCP_REPO` and
`SSG_VERSION`.

---

## Examples

```sh
make site PASSMCP_REF=v0.0.1   # build against a specific release
make data                    # rewrite the page's numbers from the sample report
make check-data              # fail if they differ, as CI does on pull requests
```

---

## When not to use satellion.com

To learn or run passmcp itself, go to
[passmcp's repository](https://github.com/sebastienrousseau/passmcp) or the
[manual](https://satellion.com/passmcp/docs/). This repository only builds the site.

---

## Development

```bash
make core
make test
make name-guard
scripts/readme-check.sh
```

Pull requests build the site and check the page's numbers. Pushes to
`main` and a daily schedule build and deploy it to GitHub Pages. Commits
follow Conventional Commits, are signed, and carry a DCO sign-off.

---

## Security

The site at <https://satellion.com/> serves static files only, sets no cookies and runs no analytics.
Report vulnerabilities according to [`SECURITY.md`](SECURITY.md).

---

## Documentation

- [satellion.com/passmcp/docs](https://satellion.com/passmcp/docs/): passmcp's manual.
- [CONTRIBUTING.md](CONTRIBUTING.md): the accuracy rule for changes here.
- [CHANGELOG.md](CHANGELOG.md): what changed on the site.

---

## Stability guarantees

These URLs are stable, because other systems resolve them: `/`,
`/passmcp/`, `/passmcp/docs/`, `/passmcp/sample/`, the Go module paths
(`/passmcp`, `/passmcp-reporting`, `/passmcp-server`, `/passmcp-graph`,
`/passmcp-registry`), and the format URIs (`/attestation/mcp-evaluation/v1`,
`/attestation/a2a-evaluation/v1`, `/graph/v1`). Layout and copy change
freely; numbers always come from a passmcp release.

---

## License

Licensed under the **[GNU General Public License v3.0](LICENSE)**, as passmcp
is.

<p align="right"><a href="#contents">Back to Top</a></p>
