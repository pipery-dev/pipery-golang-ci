#!/usr/bin/env bash
set -euo pipefail

if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
  # The Go psh binary can hit newosproc failures on hosted GitHub runners.
  # Use a bash-compatible shim so step scripts keep their psh shebang contract.
  mkdir -p /tmp/pipery-actions-bin
  printf '#!/bin/bash\nexec bash "$@"\n' > /tmp/pipery-actions-bin/psh
  chmod +x /tmp/pipery-actions-bin/psh
  echo "/tmp/pipery-actions-bin" >> "$GITHUB_PATH"
  echo "psh shim installed for GitHub Actions runner compatibility."
  exit 0
fi

echo "Installing psh..."
ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
curl -fsSL "https://github.com/pipery-dev/pipery/releases/download/v0.1.0/psh-0.1.0-linux-${ARCH}.tar.gz" \
  -o /tmp/psh.tar.gz
mkdir -p /tmp/psh-bin
tar -xzf /tmp/psh.tar.gz -C /tmp/psh-bin/
find /tmp/psh-bin -name psh -type f -exec sudo install -m755 {} /usr/local/bin/psh \;
echo "psh installed: $(command -v psh)"
