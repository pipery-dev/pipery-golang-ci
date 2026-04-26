#!/usr/bin/env bash
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

# Check if psh is functional on this platform
_psh_ok() { command -v psh &>/dev/null && psh --version &>/dev/null 2>&1; }

if _psh_ok; then
  psh -log-file "${INPUT_LOG_FILE:-pipery.jsonl}" -c "go build -v ./..."
else
  go build -v ./...
fi
