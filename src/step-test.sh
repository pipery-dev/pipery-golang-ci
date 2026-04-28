#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

TESTS_PATH="${INPUT_TESTS_PATH:-./...}"

go test -v -race "$TESTS_PATH"
