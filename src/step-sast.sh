#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

if ! command -v pipery-steps &>/dev/null; then
  echo "pipery-steps not available, skipping SAST."
  exit 0
fi

pipery-steps sast \
  --language golang \
  --project-path "$PROJECT" \
  --log-file "$LOG"
