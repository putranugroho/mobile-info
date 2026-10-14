#!/usr/bin/env bash
# Build web dengan gerbang deprecated: gagal bila ada API/library deprecated.
set -euo pipefail
cd "$(dirname "$0")/.."
tool/check_all.sh
flutter build web "$@"
