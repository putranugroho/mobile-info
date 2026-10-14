#!/usr/bin/env bash
# Build APK dengan gerbang deprecated (Gradle juga menjalankan failOnDeprecated sebelum preBuild).
set -euo pipefail
cd "$(dirname "$0")/.."
tool/check_all.sh
flutter build apk "$@"
