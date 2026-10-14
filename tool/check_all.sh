#!/usr/bin/env bash
# Semua gerbang kualitas: deprecated (kode) + paket discontinued/retracted.
set -euo pipefail
cd "$(dirname "$0")/.."
tool/check_deprecated.sh
dart tool/check_packages.dart
