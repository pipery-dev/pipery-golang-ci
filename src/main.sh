#!/usr/bin/env bash
set -euo pipefail

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION_PATH="${GITHUB_ACTION_PATH:-$(cd "$SCRIPT_DIR/.." && pwd)}"

INPUT_PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
INPUT_LOG_FILE="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"

export INPUT_PROJECT_PATH
export INPUT_LOG_FILE

# Verify project path exists
if [ ! -d "$INPUT_PROJECT_PATH" ]; then
  echo "ERROR: Project path does not exist: $INPUT_PROJECT_PATH" >&2
  exit 1
fi

echo "Starting Go CI pipeline for: $INPUT_PROJECT_PATH"
echo "Log file: $INPUT_LOG_FILE"

# Read config (non-fatal)
if [ -f "$ACTION_PATH/src/read-config.sh" ]; then
  bash "$ACTION_PATH/src/read-config.sh" || true
fi

# SAST
if [ "${INPUT_SKIP_SAST:-false}" != "true" ]; then
  echo "--- Step: SAST ---"
  bash "$ACTION_PATH/src/step-sast.sh" || true
fi

# SCA
if [ "${INPUT_SKIP_SCA:-false}" != "true" ]; then
  echo "--- Step: SCA ---"
  bash "$ACTION_PATH/src/step-sca.sh" || true
fi

# Lint
if [ "${INPUT_SKIP_LINT:-false}" != "true" ]; then
  echo "--- Step: Lint ---"
  bash "$ACTION_PATH/src/step-lint.sh"
fi

# Build
if [ "${INPUT_SKIP_BUILD:-false}" != "true" ]; then
  echo "--- Step: Build ---"
  bash "$ACTION_PATH/src/step-build.sh"
fi

# Test
if [ "${INPUT_SKIP_TEST:-false}" != "true" ]; then
  echo "--- Step: Test ---"
  bash "$ACTION_PATH/src/step-test.sh"
fi

# Version
if [ "${INPUT_SKIP_VERSIONING:-false}" != "true" ]; then
  echo "--- Step: Version ---"
  bash "$ACTION_PATH/src/step-version.sh" || true
fi

# Package
if [ "${INPUT_SKIP_PACKAGING:-false}" != "true" ]; then
  echo "--- Step: Package ---"
  bash "$ACTION_PATH/src/step-package.sh"
fi

# Release
if [ "${INPUT_SKIP_RELEASE:-false}" != "true" ]; then
  echo "--- Step: Release ---"
  bash "$ACTION_PATH/src/step-release.sh" || true
fi

# Reintegrate
if [ "${INPUT_SKIP_REINTEGRATION:-false}" != "true" ]; then
  echo "--- Step: Reintegrate ---"
  bash "$ACTION_PATH/src/step-reintegrate.sh" || true
fi

# Write final success log entry
printf '{"event":"build","status":"success","project":"golang","mode":"ci"}\n' >> "${INPUT_LOG_FILE:-pipery.jsonl}"

echo "Go CI pipeline complete."
