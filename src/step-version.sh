#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if ! command -v pipery-steps &>/dev/null; then
  echo "pipery-steps not available, skipping versioning."
  exit 0
fi

VERSION_OUTPUT=$(pipery-steps \
  --project-path "$PROJECT" \
  --log-file "$LOG" \
  version \
  --language golang \
  --bump "${INPUT_VERSION_BUMP:-patch}" 2>&1) || {
  echo "Versioning step completed with warnings: $VERSION_OUTPUT (non-fatal)."
  printf '{"event":"version","status":"skipped","reason":"%s"}\n' "version_file_not_found" >> "$LOG"
  exit 0
}

NEW_VERSION="$(echo "$VERSION_OUTPUT" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | tail -1 || true)"
echo "New version: $NEW_VERSION"
[ -n "${GITHUB_OUTPUT:-}" ] && echo "version=$NEW_VERSION" >> "$GITHUB_OUTPUT"
printf '{"event":"version","status":"success","version":"%s"}\n' "$NEW_VERSION" >> "$LOG"
