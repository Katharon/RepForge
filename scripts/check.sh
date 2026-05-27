#!/usr/bin/env bash
set -euo pipefail

flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
