<!-- SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com> -->
<!-- SPDX-License-Identifier: GPL-3.0-only -->

# Architecture Decision Records

Decisions about this repository that will be questioned later, with the
reasoning that produced them. Records are immutable once merged; a
decision that changes gets a new record superseding the old one.

Decisions about passmcp itself, its checks, its score and its formats, are
passmcp's, in [passmcp's ADRs](https://github.com/sebastienrousseau/passmcp/blob/main/docs/adr/README.md).
The four records below were made with the first commit and written down
afterwards, from the Makefile, `ssg.toml` and the scripts that enforce
them.

| # | Decision | Status |
|---|---|---|
| [0001](0001-build-against-a-passmcp-release.md) | Build the site against a passmcp release, never a branch | Accepted |
| [0002](0002-core-build-needs-no-release.md) | A core build that needs no passmcp release | Accepted |
| [0003](0003-static-site-not-the-application.md) | The site is static, and is not passmcp's application | Accepted |
| [0004](0004-go-module-paths-served-and-checked.md) | Serve the family's Go module paths, and fail the build when one breaks | Accepted |
