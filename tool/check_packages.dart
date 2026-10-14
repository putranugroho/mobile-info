// Gerbang paket: gagal (exit 1) bila dependency LANGSUNG discontinued atau versinya retracted.
// Paket transitive discontinued dan paket yang tertinggal versi hanya dilaporkan.
// Butuh koneksi ke pub.dev; bila tidak bisa dijangkau, gerbang tetap GAGAL (fail closed).
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final dart = Platform.resolvedExecutable;
  final res = await Process.run(dart, ['pub', 'outdated', '--json']);
  if (res.exitCode != 0) {
    stderr.writeln('GAGAL: tidak bisa menjalankan `dart pub outdated` (periksa koneksi ke pub.dev).\n${res.stderr}');
    exit(1);
  }
  final data = jsonDecode(res.stdout as String) as Map<String, dynamic>;
  final packages = (data['packages'] as List).cast<Map<String, dynamic>>();

  final bad = <String>[];
  final info = <String>[];
  var outdated = 0;
  for (final p in packages) {
    final name = p['package'] as String;
    final kind = (p['kind'] ?? '') as String; // direct | dev | transitive
    final isDirect = kind == 'direct' || kind == 'dev';
    final discontinued = p['isDiscontinued'] == true;
    final retracted = p['isCurrentRetracted'] == true;
    if (isDirect && discontinued) bad.add('$name: paket DISCONTINUED (ganti dengan alternatif)');
    if (isDirect && retracted) bad.add('$name: versi terpasang RETRACTED (naikkan versi)');
    if (!isDirect && discontinued) info.add('$name (transitive) discontinued');
    final cur = (p['current'] as Map?)?['version'];
    final latest = (p['latest'] as Map?)?['version'];
    if (isDirect && cur != null && latest != null && cur != latest) outdated++;
  }

  for (final m in info) {
    stdout.writeln('info: $m');
  }
  if (outdated > 0) stdout.writeln('info: $outdated dependency langsung tertinggal versi (cek: flutter pub outdated)');
  if (bad.isNotEmpty) {
    stderr.writeln('\nGERBANG PAKET GAGAL:');
    for (final m in bad) {
      stderr.writeln('  - $m');
    }
    exit(1);
  }
  stdout.writeln('OK: tidak ada dependency langsung yang discontinued/retracted.');
}
