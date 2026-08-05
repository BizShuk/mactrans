#!/usr/bin/env bash
# Packages MacTrans.app and mactrans CLI into a release archive in dist/.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/build.sh"

DIST="$ROOT/dist"
STAGING="$DIST/staging"

rm -rf "$DIST"
mkdir -p "$STAGING"

cp -R "$ROOT/.build/MacTrans.app" "$STAGING/MacTrans.app"
cp "$ROOT/.build/release/mactrans" "$STAGING/mactrans"
cp "$ROOT/scripts/install.sh" "$STAGING/install.sh"
chmod +x "$STAGING/install.sh"

cd "$STAGING"
zip -r "$DIST/MacTrans-macOS-arm64.zip" MacTrans.app mactrans install.sh

echo "Package created at: $DIST/MacTrans-macOS-arm64.zip"
