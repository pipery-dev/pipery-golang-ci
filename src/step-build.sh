#!/usr/bin/env psh
set -euo pipefail

cd "${INPUT_PROJECT_PATH:-.}"

TARGET_PLATFORMS="${INPUT_TARGET_PLATFORMS:-}"

_platforms() {
  if [ -n "$TARGET_PLATFORMS" ]; then
    printf '%s\n' "$TARGET_PLATFORMS" | sed 's/[[:space:],][[:space:],]*/\
/g; /^$/d'
  fi
}

if [ -z "$TARGET_PLATFORMS" ]; then
  go build -v ./...
  exit 0
fi

for PLATFORM in $(_platforms); do
  OS="${PLATFORM%/*}"
  ARCH="${PLATFORM#*/}"
  if [ -z "$OS" ] || [ -z "$ARCH" ] || [ "$OS" = "$ARCH" ]; then
    echo "Invalid target platform '$PLATFORM'. Expected GOOS/GOARCH, e.g. linux/amd64." >&2
    exit 1
  fi
  echo "Cross-compiling Go packages for ${OS}/${ARCH}..."
  GOOS="$OS" GOARCH="$ARCH" go build -v ./...
done
