#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
TOKEN="${INPUT_GITHUB_TOKEN:-${GITHUB_TOKEN:-}}"

if [ -z "$TOKEN" ]; then
  echo "No GITHUB_TOKEN available, skipping reintegration."
  exit 0
fi

if ! command -v pipery-steps &>/dev/null; then
  echo "pipery-steps not available, skipping reintegration."
  exit 0
fi

export GITHUB_TOKEN="$TOKEN"

pipery-steps reintegrate \
  --log-file "$LOG" \
  || echo "Reintegration step completed (non-fatal)"
