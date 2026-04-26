#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

mkdir -p dist

for OS in linux darwin windows; do
  EXT=""
  [ "$OS" = "windows" ] && EXT=".exe"
  GOOS="$OS" GOARCH=amd64 go build -v -o "dist/${OS}-amd64/app${EXT}" ./...
done
