#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

go build -v ./...
