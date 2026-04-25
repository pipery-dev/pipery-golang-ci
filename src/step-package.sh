#!/usr/bin/env bash
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

mkdir -p dist

# Check if psh is functional on this platform
_psh_ok() { command -v psh &>/dev/null && psh --version &>/dev/null 2>&1; }

for OS in linux darwin windows; do
  EXT=""
  [ "$OS" = "windows" ] && EXT=".exe"
  if _psh_ok; then
    psh -log-file "$LOG" -c "GOOS=$OS GOARCH=amd64 go build -v -o dist/${OS}-amd64/app${EXT} ./..."
  else
    GOOS="$OS" GOARCH=amd64 go build -v -o "dist/${OS}-amd64/app${EXT}" ./...
  fi
done
