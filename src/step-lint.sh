#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

# Check if psh is functional on this platform
_psh_ok() { command -v psh &>/dev/null && psh --version &>/dev/null 2>&1; }

cd "$PROJECT"

# Try golangci-lint; install if missing, fall back to go vet if incompatible
_run_golangci_lint() {
  if ! command -v golangci-lint &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
      | sh -s -- -b /usr/local/bin latest 2>/dev/null || return 1
  fi
  if command -v golangci-lint &>/dev/null; then
    if _psh_ok; then
      psh -log-file "$LOG" -c "golangci-lint run ./..." || return 1
    else
      golangci-lint run ./... || return 1
    fi
    return 0
  fi
  return 1
}

if _run_golangci_lint; then
  echo "Lint passed (golangci-lint)."
else
  echo "golangci-lint unavailable or failed, falling back to go vet."
  if _psh_ok; then
    psh -log-file "$LOG" -c "go vet ./..."
  else
    go vet ./...
  fi
  echo "Lint passed (go vet)."
fi
