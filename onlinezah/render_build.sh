#!/usr/bin/env bash
# Render дээр Flutter суулгаад web хувилбарыг build хийнэ.
set -euo pipefail

FLUTTER_VERSION="3.47.5"
FLUTTER_DIR="$HOME/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git \
    --branch "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --no-analytics
flutter --version
flutter pub get
flutter build web --release
