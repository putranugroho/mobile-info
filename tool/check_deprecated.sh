#!/usr/bin/env bash
# Gagal (exit != 0) jika ada pemakaian API/library deprecated di lib/.
set -euo pipefail
cd "$(dirname "$0")/.."
flutter analyze --no-fatal-infos --no-fatal-warnings
echo "OK: tidak ada pemakaian deprecated."
