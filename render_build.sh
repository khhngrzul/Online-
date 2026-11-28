#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.5"
FLUTTER_DIR="$HOME/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git \
    --branch "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter config --no-analytics
flutter pub get
flutter build web --release \
  --dart-define="API_BASE_URL=https://${API_HOST}"
