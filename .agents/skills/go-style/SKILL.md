---
name: go-style
description: Go style guide, modules troubleshooting, and testing best practices
allowed-tools: All tools
user-invocable: true
---

# Go Style and Modules

## Go Style

Always prefer functions from the Go standard library over implementing equivalent functionality ourselves. Before writing custom logic, check whether the stdlib already provides it.

## Go Modules (Datadog Internal)

`go.ddbuild.io` modules are served from Datadog internal infrastructure and require VPN to download. If `go get` or `go mod download` times out, check VPN connectivity first.

**Workaround when offline:** Add a temporary `replace` directive in `go.mod` pointing to a locally-cached version in `~/go/pkg/mod`. Revert before committing.

## Testing

All applicable tests must be run and pass before committing. Check for a Makefile and run all relevant targets (e.g. `make test`). If a linter is available, run it too (e.g. `make lint`) and resolve any issues before committing. Make targets can be run in parallel.

This applies to every commit without exception — including trivial changes like `go mod tidy`, dependency updates, or import reordering. Skipping fmt/lint/test for "minor" changes is not acceptable.

In Go tests, prefer `t.Context()` over `context.Background()`. Note that removing `context.Background()` calls does not necessarily make the `context` import unused — method signatures may still reference `context.Context`.
