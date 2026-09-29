# SPDX-FileCopyrightText: 2026 Sebastien Rousseau <sebastian.rousseau@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only
#
# Build satellion.com from this repository and a release of passmcp.
#
# The site shows passmcp's real output, so it is built against a passmcp
# release: the sample report is passmcp run against its fixture server, the
# manual is passmcp's docs/, and the page's numbers come from that report.

.PHONY: all core site passmcp sample data check-data manual test serve clean help name-guard

PASSMCP_REPO ?= https://github.com/sebastienrousseau/passmcp
# The latest release tag unless one is named: make site PASSMCP_REF=v0.0.1
PASSMCP_REF  ?= $(shell git ls-remote --tags --refs --sort=-v:refname $(PASSMCP_REPO) 'v*' | head -n1 | sed 's|.*refs/tags/||')
SSG_VERSION ?= 0.0.63
WORK := .build
DIST := dist

all: site

# passmcp at the release, checked out once per ref.
passmcp:
	@test -n "$(PASSMCP_REF)" || { echo "no passmcp release found" >&2; exit 1; }
	@if [ "$$(git -C $(WORK)/passmcp describe --tags --exact-match 2>/dev/null)" != "$(PASSMCP_REF)" ]; then \
	  rm -rf $(WORK)/passmcp; \
	  git clone --quiet --depth 1 --branch $(PASSMCP_REF) $(PASSMCP_REPO) $(WORK)/passmcp; \
	fi
	cd $(WORK)/passmcp && go build -o ../passmcp-bin ./cmd/passmcp

# passmcp's own sample report: passmcp run against its deliberately flawed fixture.
sample: passmcp
	rm -rf $(WORK)/sample
	cd $(WORK)/passmcp && go run ./scripts/samplereport/main.go ../passmcp-bin ../sample

# The page's score, grade, counts and ledger, from that report.
data: sample
	python3 scripts/site_data.py $(WORK)/sample/report.json content/passmcp/index.md $(WORK)/passmcp/docs/checks.md

check-data: sample
	python3 scripts/site_data.py $(WORK)/sample/report.json content/passmcp/index.md $(WORK)/passmcp/docs/checks.md --check

# The site's own scripts' tests (python3's unittest; no dependencies).
test:
	python3 -m unittest discover -s scripts -p 'test_*.py'

manual: passmcp
	python3 -m venv $(WORK)/venv
	$(WORK)/venv/bin/pip install --quiet --disable-pip-version-check --require-hashes -r $(WORK)/passmcp/docs/requirements.txt
	cd $(WORK)/passmcp && ../venv/bin/mkdocs build --strict --site-dir $(CURDIR)/$(WORK)/manual

# Always from the release being built, so a deployed page cannot show another
# release's numbers. Pull requests also run check-data, so the committed page
# is kept equal to what gets deployed.
# core is everything that needs no passmcp release: the company page, the
# product page with its committed numbers, the Go module and format pages,
# both icon sets and security.txt. It is what deploys before the first
# release exists, because Go needs the module pages to fetch that release.
core:
	@v=$$(ssg --version 2>/dev/null | awk '{print $$2}'); [ "$$v" = "$(SSG_VERSION)" ] || { echo "ssg $(SSG_VERSION) required, found '$$v'" >&2; exit 1; }
	ssg build -f ssg.toml
	# SSG renders pages and templates; static files are copied after it,
	# because it wipes its output directory on every build.
	mkdir -p $(DIST)/images && cp -R images/. $(DIST)/images/
	# Satellion's icons at the root, passmcp's beside its pages.
	mkdir -p $(DIST)/brand && cp -R brand/satellion $(DIST)/brand/
	cp brand/satellion/favicon.ico brand/satellion/favicon.svg brand/satellion/apple-touch-icon.png $(DIST)/
	mkdir -p $(DIST)/passmcp && cp brand/passmcp/* $(DIST)/passmcp/
	# SSG 0.0.63 links /highlight.css but writes it fingerprinted; publish
	# it under the linked name too until SSG rewrites that link itself.
	for f in $(DIST)/highlight.*.css; do [ -e "$$f" ] && cp "$$f" $(DIST)/highlight.css; done
	# security.txt (RFC 9116), from content/index.md's security_* keys. SSG
	# writes it at the root; the RFC's location is /.well-known/. The check
	# fails the build when Expires is under 30 days away (EU CRA).
	python3 scripts/security_txt.py $(DIST)/security.txt
	mkdir -p $(DIST)/.well-known && cp $(DIST)/security.txt $(DIST)/.well-known/security.txt
	python3 scripts/modules.py $(DIST)
	echo satellion.com > $(DIST)/CNAME
	@echo "core: built $(DIST)"

# site is core plus what comes from the passmcp release: the numbers on the
# product page, the manual and the sample report.
site: data manual core
	cp -R $(WORK)/manual $(DIST)/passmcp/docs
	cp -R $(WORK)/sample $(DIST)/passmcp/sample
	# Last, because it indexes the finished tree.
	cd $(WORK)/passmcp && go run ./scripts/sitemap/main.go $(CURDIR)/$(DIST)
	@echo "site: built $(DIST) against passmcp $(PASSMCP_REF)"

serve: site
	cd $(DIST) && python3 -m http.server 8000

clean:
	rm -rf $(WORK) $(DIST)

help:
	@grep -E '^[a-z-]+:' $(MAKEFILE_LIST) | cut -d: -f1 | sort -u

# The project's retired names may not appear anywhere in this repository.
name-guard:
	./scripts/name-guard.sh
