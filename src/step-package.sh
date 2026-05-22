#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

mkdir -p dist
TARGET_PLATFORMS="${INPUT_TARGET_PLATFORMS:-linux/amd64,darwin/amd64,windows/amd64}"

_platforms() {
  printf '%s\n' "$TARGET_PLATFORMS" | sed 's/[[:space:],][[:space:],]*/\
/g; /^$/d'
}

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

for PLATFORM in $(_platforms); do
  OS="${PLATFORM%/*}"
  ARCH="${PLATFORM#*/}"
  if [ -z "$OS" ] || [ -z "$ARCH" ] || [ "$OS" = "$ARCH" ]; then
    echo "Invalid target platform '$PLATFORM'. Expected GOOS/GOARCH, e.g. linux/amd64." >&2
    exit 1
  fi
  EXT=""
  [ "$OS" = "windows" ] && EXT=".exe"
  mkdir -p "dist/${OS}-${ARCH}"
  for COMMAND in "${COMMANDS[@]}"; do
    NAME="$(basename "$COMMAND")"
    [ "$COMMAND" = "." ] && NAME="$(basename "$(pwd)")"
    ARTIFACT="dist/${OS}-${ARCH}/${NAME}-${OS}-${ARCH}${EXT}"
    GOOS="$OS" GOARCH="$ARCH" go build -v -o "$ARTIFACT" "./${COMMAND#./}"
    printf '{"event":"cross_compile","status":"success","language":"golang","target":"%s/%s","artifact":"%s"}\n' "$OS" "$ARCH" "$ARTIFACT" >> "${INPUT_LOG_FILE:-pipery.jsonl}"
  done
done
