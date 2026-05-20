#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

mkdir -p dist

COMMANDS=()
if [ -d cmd ]; then
  while IFS= read -r dir; do
    [ -f "$dir/main.go" ] || continue
    COMMANDS+=("$dir")
  done < <(find cmd -mindepth 1 -maxdepth 1 -type d | sort)
fi

if [ "${#COMMANDS[@]}" -eq 0 ] && ls ./*.go >/dev/null 2>&1 && grep -q '^package main$' ./*.go; then
  COMMANDS+=(".")
fi

if [ "${#COMMANDS[@]}" -eq 0 ]; then
  echo "No Go command packages found, skipping packaging."
  exit 0
fi

for OS in linux darwin windows; do
  EXT=""
  [ "$OS" = "windows" ] && EXT=".exe"
  mkdir -p "dist/${OS}-amd64"
  for COMMAND in "${COMMANDS[@]}"; do
    NAME="$(basename "$COMMAND")"
    [ "$COMMAND" = "." ] && NAME="$(basename "$(pwd)")"
    GOOS="$OS" GOARCH=amd64 go build -v -o "dist/${OS}-amd64/${NAME}${EXT}" "./${COMMAND#./}"
  done
done
