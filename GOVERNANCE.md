<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# Governance

satellion.com is one repository in the passmcp family and is governed the
way passmcp is. This document says what is specific to this repository and
points at passmcp's for the rest.

## Roles

**Maintainer:** Sebastien Rousseau (<sebastian.rousseau@gmail.com>,
GitHub `@sebastienrousseau`), with commit access, responsible for the
site's content, its deployment, the `satellion.com` domain and its
security response.

**Contributor:** anyone who opens an issue or a pull request. Mechanics
are in [CONTRIBUTING.md](CONTRIBUTING.md).

## What is decided here, and what is not

This repository decides **what the site says and serves**: its copy, its
layouts, and the module and format URLs it publishes. Changing or removing
a URL listed under the README's stability guarantees needs a record in
[docs/adr/](docs/adr/README.md), because other systems resolve it.

It does not decide **passmcp's figures**: the check count, the sample
report and the manual come from a passmcp release (ADR 0001).

## Version and release

The version is the family's, in lockstep (see
[DEVELOPMENT.md](DEVELOPMENT.md#release-model)). Releases are signed tags,
cut by the Maintainer.

## Continuity

The single-Maintainer model is a real bus-factor risk, stated rather than
hidden. The succession procedure is passmcp's, in
[passmcp's GOVERNANCE.md](https://github.com/sebastienrousseau/passmcp/blob/main/GOVERNANCE.md),
and applies to this repository as one of the family. GPL-3.0-only lets
anyone fork the site's source under the same licence; the Satellion name
and marks are not licensed.

## Changes to this document

Through the usual pull request process.
