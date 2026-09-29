<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# Development

The single entry point for working on satellion.com: the toolchain, the
local equivalent of every CI gate, the tests and the release model. How the
build works is in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Requirements

| Tool | Version | Needed for | Enforced by |
|---|---|---|---|
| Python | 3.12 or later | `make test`, `make coverage`, `make core` | `ci.yml` and `pages.yml` run 3.12 |
| SSG | exactly 0.0.63 | `make core`, `make site` | the Makefile's `core` target refuses any other version |
| Go | stable | `make site` (builds passmcp) | `pages.yml` |
| git, network access to GitHub | any | `make site` (clones passmcp at a release) | `pages.yml` |
| Node.js (`npx`), codespell | any | `make lint` | `docs-lint.yml` |

Install SSG with Cargo:

```sh
cargo install ssg --locked --version 0.0.63
```

`make coverage` and `make complexity` create `.build/venv-test` and install
coverage.py, xenon and complexipy from the hash-locked
`scripts/requirements.txt`; nothing is installed globally.

## Gates

`make check` runs every gate that needs no passmcp release. Each row is a
CI job; the command reproduces it locally.

| Gate | Command | CI |
|---|---|---|
| The scripts' tests | `make test` | `ci.yml`, `pages.yml` |
| Coverage at 85% or more | `make coverage` | `ci.yml`, `pages.yml` |
| Complexity: cyclomatic 10, cognitive 15 per function | `make complexity` | `ci.yml` |
| Every version reference agrees | `make verify-versions` | `ci.yml` |
| The core pages build | `make core` | `ci.yml`, `pages.yml` |
| The full site builds against a passmcp release | `make site` | `pages.yml` |
| The product page's numbers match the release | `make check-data` | `pages.yml` on pull requests |
| The family table matches the release's `ecosystem.json` | `make check-family` | `pages.yml` on pull requests |
| README follows the template | `make readme-check` | `docs-lint.yml`, `pages.yml` |
| No retired product name | `make name-guard` | `docs-lint.yml`, `pages.yml` |
| Markdown and spelling | `make lint` | `docs-lint.yml` |
| REUSE compliance | `reuse lint` | `docs-lint.yml` |
| Relative links resolve | `lychee --offline --include-fragments --exclude-path content '**/*.md'` | `docs-lint.yml` |
| Every PR commit has a DCO sign-off | (CI only) | `dco.yml` |
| The PR targets `main` | (CI only) | `pr-base.yml` |
| CodeQL and OpenSSF Scorecard | (CI only) | `codeql.yml`, `scorecard.yml` |

`pre-commit install` runs the cheap ones before each commit
(`.pre-commit-config.yaml`).

## Tests

The build's helpers are Python scripts in `scripts/`, each with a
`test_<name>.py` beside it, run by the standard library's `unittest`:

```sh
make test
```

The tests need no network, no browser and no SSG: `test_cards.py` stands a
stub in for Chrome, and `test_site_data.py` runs against a throwaway copy of
the files it rewrites.

## Coverage

`make coverage` runs the same tests under coverage.py with branch
coverage (`.coveragerc`), fails below 85%, the passmcp family's gate, and
writes `.build/coverage.json`, a shields.io endpoint document. `pages.yml`
publishes that file at <https://satellion.com/coverage.json>, which the
README's coverage badge reads; the figure is statement coverage, truncated to
one decimal, in the family's colour bands.

## Release model

satellion.com is versioned with the passmcp family: every repository is at
the same version, and each release moves it by 0.0.1. The version is the
newest `## [x.y.z]` heading in [CHANGELOG.md](CHANGELOG.md), with its
highlights in `docs/releases/v<x.y.z>.md`. `make verify-versions` fails when
the README's ecosystem section, a module page's `go install` line or the
passmcp release the product page was built against says otherwise.

Releases are signed annotated tags cut by the maintainer. The site itself
deploys from `main`, so a merged change is live without a release.
