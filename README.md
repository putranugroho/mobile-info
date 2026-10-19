# ibpr

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Gerbang kualitas (build gagal bila dilanggar)

Dua gerbang, dijalankan bersama oleh `tool/check_all.sh`:

1. **Deprecated (kode)** — `analysis_options.yaml`: `deprecated_member_use` = **error** (`tool/check_deprecated.sh`).
2. **Paket** — `tool/check_packages.dart`: gagal bila dependency **langsung** discontinued atau versinya retracted.
   Paket transitive discontinued dan paket yang tertinggal versi hanya dilaporkan. Butuh koneksi ke pub.dev (fail closed).

Di mana gerbang dipasang:
- **Android (APK/AAB)**: `android/app/build.gradle` — task `failOnDeprecated` + `failOnBadPackages` terpasang di `preBuild` dan `assemble*`/`bundle*`, jadi `flutter build apk|appbundle` gagal di komputer mana pun.
- **Semua platform termasuk web**: `tool/gate` (paket `build_gate`) terdaftar sebagai *asset transformer* di `pubspec.yaml` (aset `assets/gate/gate.txt`). Flutter menjalankannya di setiap `flutter build web|apk|ios` dan `flutter run`; bila gerbang gagal, build gagal. Tidak perlu skrip khusus. Tambah ~5–10 detik per build (dart analyze + cek pub.dev).
- **Git**: `git config core.hooksPath .githooks` (sekali per clone) menolak commit/push yang melanggar.
- Untuk penguncian yang tidak bisa dilewati, jalankan `tool/check_all.sh` di CI dan wajibkan lulus sebelum merge.
