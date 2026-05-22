#!/usr/bin/env psh
set -euo pipefail

TOKEN="${INPUT_GITHUB_TOKEN:-${GITHUB_TOKEN:-}}"
SHORT_SHA="${GITHUB_SHA:-}"
SHORT_SHA="${SHORT_SHA:0:7}"

if [ -z "$TOKEN" ] || { [ "${GITHUB_REF_TYPE:-}" != "tag" ] && [[ "${GITHUB_REF:-}" != refs/tags/* ]]; }; then
  echo "No GITHUB_TOKEN or not on a tag, skipping release."
  exit 0
fi

export GITHUB_TOKEN="$TOKEN"

RELEASE_TITLE="${GITHUB_REF_NAME}${SHORT_SHA:+ (sha-${SHORT_SHA})}"
ASSETS=()
if [ -d dist ]; then
  while IFS= read -r -d '' asset; do
    ASSETS+=("$asset")
  done < <(find dist -type f -print0)
fi

if gh release view "${GITHUB_REF_NAME}" >/dev/null 2>&1; then
  if [ "${#ASSETS[@]}" -gt 0 ]; then
    gh release upload "${GITHUB_REF_NAME}" "${ASSETS[@]}" --clobber
  fi
else
  if [ "${#ASSETS[@]}" -gt 0 ]; then
    gh release create "${GITHUB_REF_NAME}" "${ASSETS[@]}" --generate-notes --title "$RELEASE_TITLE"
  else
    gh release create "${GITHUB_REF_NAME}" --generate-notes --title "$RELEASE_TITLE"
  fi
fi
