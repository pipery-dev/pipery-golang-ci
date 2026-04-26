#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
TOKEN="${INPUT_GITHUB_TOKEN:-${GITHUB_TOKEN:-}}"
SHORT_SHA="${GITHUB_SHA:0:7}"

if [ -z "$TOKEN" ] || [ -z "${GITHUB_REF_NAME:-}" ]; then
  echo "No GITHUB_TOKEN or not on a tag, skipping release."
  exit 0
fi

export GITHUB_TOKEN="$TOKEN"

RELEASE_TITLE="${GITHUB_REF_NAME} (sha-${SHORT_SHA})"

# Check if psh is functional on this platform
_psh_ok() { command -v psh &>/dev/null && psh --version &>/dev/null 2>&1; }

if _psh_ok; then
  psh -log-file "$LOG" -c "gh release create ${GITHUB_REF_NAME} dist/**/* --generate-notes --title '${RELEASE_TITLE}'" \
    || echo "Release create failed (may already exist)"
else
  gh release create "${GITHUB_REF_NAME}" dist/**/* --generate-notes --title "${RELEASE_TITLE}" \
    || echo "Release create failed (may already exist)"
fi
