// Asset transformer: dijalankan Flutter setiap kali aset di-bundle (flutter build web/apk/ios).
// Bila gerbang gagal, exit != 0 sehingga build Flutter ikut GAGAL.
import 'dart:io';

Future<int> _run(String exe, List<String> args) async {
  final p = await Process.start(exe, args, mode: ProcessStartMode.inheritStdio);
  return p.exitCode;
}

Future<void> main(List<String> args) async {
  String? input, output;
  for (final a in args) {
    if (a.startsWith('--input=')) input = a.substring(8);
    if (a.startsWith('--output=')) output = a.substring(9);
  }
  if (input == null || output == null) {
    stderr.writeln('build_gate: --input/--output wajib');
    exit(2);
  }

  // Input adalah salinan di folder temp, jadi cari root project dari direktori kerja (Flutter menjalankan `dart run` di root project).
  var dir = Directory.current.absolute;
  while (!File('${dir.path}/pubspec.yaml').existsSync() || !Directory('${dir.path}/lib').existsSync()) {
    if (dir.parent.path == dir.path) {
      stderr.writeln('build_gate: root project tidak ditemukan');
      exit(2);
    }
    dir = dir.parent;
  }
  final root = dir.path;
  final dart = Platform.resolvedExecutable;

  stdout.writeln('== build_gate: cek deprecated (dart analyze) ==');
  final a = await Process.start(dart, ['analyze', '--no-fatal-warnings', 'lib'], workingDirectory: root, mode: ProcessStartMode.inheritStdio);
  if (await a.exitCode != 0) {
    stderr.writeln('\nBUILD DIGAGALKAN: ada pemakaian API/library deprecated (lihat error di atas).');
    exit(1);
  }

  stdout.writeln('== build_gate: cek paket discontinued/retracted ==');
  final b = await Process.start(dart, ['tool/check_packages.dart'], workingDirectory: root, mode: ProcessStartMode.inheritStdio);
  if (await b.exitCode != 0) {
    stderr.writeln('\nBUILD DIGAGALKAN: ada dependency langsung discontinued/retracted.');
    exit(1);
  }

  File(input).copySync(output);
}
