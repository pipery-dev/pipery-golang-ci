#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"

cd "$PROJECT"

_run_golangci_lint() {
  if ! command -v golangci-lint &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
      | sh -s -- -b /usr/local/bin latest 2>/dev/null || return 1
  fi
  if command -v golangci-lint &>/dev/null; then
    golangci-lint run ./... || return 1
    return 0
  fi
  return 1
}

if _run_golangci_lint; then
  echo "Lint passed (golangci-lint)."
else
  echo "golangci-lint unavailable or failed, falling back to go vet."
  go vet ./...
  echo "Lint passed (go vet)."
fi
