import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobile_info/models/deposito_detail_model.dart';
import 'package:mobile_info/models/deposito_digital_model.dart';
import 'package:mobile_info/models/deposito_model.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/module/deposito/bilyet_pdf.dart';
import 'package:mobile_info/module/deposito/deposito_detail_page.dart';
import 'package:mobile_info/module/repository/deposito_digital_repository.dart';
import 'package:mobile_info/module/repository/deposito_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:mobile_info/utils/terbilang.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _biru = Color(0xFF1565C0);

String _fmtTanggal(String raw) {
  final s = raw.trim();
  DateTime? d;
  if (RegExp(r'^\d{8}$').hasMatch(s)) {
    d = DateTime.tryParse('${s.substring(0, 4)}-${s.substring(4, 6)}-${s.substring(6, 8)}');
  } else {
    d = DateTime.tryParse(s);
  }
  return d == null ? (s.isEmpty ? '-' : s) : DateFormat('dd-MM-yyyy').format(d);
}

/// Popup saat deposito di home diklik. Menu digital hanya muncul untuk deposito digital.
void showDepositoActionSheet(
  BuildContext context, {
  required DepositoModel deposito,
  required DepositoDigitalInfo? digitalInfo,
  required List<TabunganModel> tabungan,
}) {
  final digital = digitalInfo != null;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) {
      Widget item(IconData icon, String title, String subtitle, VoidCallback onTap) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _biru.withValues(alpha: 0.1),
            child: Icon(icon, color: _biru),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pop(sheetContext);
            onTap();
          },
        );
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Text(deposito.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(deposito.noAcc, style: const TextStyle(color: Colors.grey)),
              if (digital)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Deposito Digital • ${digitalInfo.noBilyet}', style: const TextStyle(color: _biru, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 8),
              item(Icons.info_outline, 'Detail Deposito', 'Lihat rincian deposito', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DepositoDetailPage(noRekening: deposito.noAcc)));
              }),
              if (digital) ...[
                item(Icons.lock_clock_outlined, 'Penutupan Deposito Digital', 'Ajukan pencairan deposito ke tabungan', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PenutupanDepositoPage(deposito: deposito, tabungan: tabungan),
                    ),
                  );
                }),
                item(Icons.picture_as_pdf_outlined, 'Cetak Bilyet Digital', 'Lihat dan cetak bilyet deposito', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CetakBilyetPage(deposito: deposito, digitalInfo: digitalInfo),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      );
    },
  );
}

// ============================ PENUTUPAN ============================

/// Estimasi nominal penutupan. CATATAN: aturan bunga/penalty/pajak final ditetapkan BPR;
/// penalty belum punya rumus dari backend sehingga dihitung 0.
class PenutupanEstimate {
  final double pokok;
  final double bunga;
  final double penalty;
  final double pajak;

  const PenutupanEstimate({required this.pokok, required this.bunga, required this.penalty, required this.pajak});

  double get diterima => pokok + bunga - penalty - pajak;

  static PenutupanEstimate hitung(DepositoDetailModel d, DateTime now) {
    DateTime? parse(String s) => RegExp(r'^\d{8}$').hasMatch(s) ? DateTime.tryParse('${s.substring(0, 4)}-${s.substring(4, 6)}-${s.substring(6, 8)}') : null;
    final eff = parse(d.tglEff);
    final jt = parse(d.tglJatuhTempo);
    var hari = 0;
    if (eff != null) {
      hari = now.difference(eff).inDays;
      if (jt != null) hari = hari.clamp(0, jt.difference(eff).inDays);
      if (hari < 0) hari = 0;
    }
    final bunga = (d.nominal * d.rate / 100 * hari / 365).roundToDouble();
    final pajak = (bunga * 0.20).roundToDouble(); // PPh bunga 20%
    return PenutupanEstimate(pokok: d.nominal, bunga: bunga, penalty: 0, pajak: pajak);
  }
}

class PenutupanDepositoPage extends StatefulWidget {
  final DepositoModel deposito;
  final List<TabunganModel> tabungan;
  const PenutupanDepositoPage({super.key, required this.deposito, required this.tabungan});

  @override
  State<PenutupanDepositoPage> createState() => _PenutupanDepositoPageState();
}

class _PenutupanDepositoPageState extends State<PenutupanDepositoPage> {
  DepositoDetailModel? _detail;
  PenutupanEstimate? _est;
  String? _error;
  bool _loading = true;
  bool _submitting = false;
  String? _rekTab;

  @override
  void initState() {
    super.initState();
    if (widget.tabungan.isNotEmpty) _rekTab = widget.tabungan.first.noAcc;
    _load();
  }

  Future<void> _load() async {
    try {
      final users = await Pref().getUsers();
      final d = await DepositoRepository.getDetailDeposito(noRek: widget.deposito.noAcc, userlogin: users.usersId, bprId: users.bprId);
      setState(() {
        _detail = d;
        _est = PenutupanEstimate.hitung(d, DateTime.now());
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat detail deposito.';
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    final d = _detail!;
    final est = _est!;
    if (_rekTab == null) return _snack('Pilih rekening tabungan tujuan pencairan.');

    final users = await Pref().getUsers();
    if (users.kdKantor.trim().isEmpty) return _snack('Kode kantor tidak ditemukan. Silakan login ulang.');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajukan penutupan?'),
        content: Text('Deposito ${d.noRek} akan diajukan untuk ditutup dan dicairkan ke tabungan $_rekTab.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ajukan')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _submitting = true);
    try {
      final msg = await DepositoDigitalRepository.daftarPenutupan(
        bprId: users.bprId,
        noCif: users.noCif,
        nama: d.nama,
        kdKantor: users.kdKantor.trim(),
        noDep: d.noRek,
        tglJtempo: d.tglJatuhTempo,
        rekTab: _rekTab!,
        pokok: est.pokok,
        bunga: est.bunga,
        penalty: est.penalty,
        pajak: est.pajak,
        userLogin: users.usersId,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Permohonan terkirim'),
          content: Text(msg),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Widget _row(String k, String v, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(v, textAlign: TextAlign.right, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ),
      ],
    ),
  );

  String _rp(double v) => 'Rp ${FormatCurrency.oCcy.format(v)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(title: const Text('Penutupan Deposito Digital'), backgroundColor: _biru, foregroundColor: Colors.white),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row('Produk', widget.deposito.namaProduk),
                        _row('No. Deposito', _detail!.noRek),
                        _row('Nama', _detail!.nama),
                        _row('Jatuh Tempo', _fmtTanggal(_detail!.tglJatuhTempo)),
                        _row('Suku Bunga', '${_detail!.rate.toStringAsFixed(2)} %'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row('Pokok', _rp(_est!.pokok)),
                        _row('Bunga berjalan', _rp(_est!.bunga)),
                        _row('Penalty', _rp(_est!.penalty)),
                        _row('Pajak bunga', _rp(_est!.pajak)),
                        const Divider(),
                        _row('Estimasi diterima', _rp(_est!.diterima), bold: true),
                        const SizedBox(height: 6),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Nominal di atas adalah estimasi. Nilai final ditetapkan BPR saat permohonan diproses.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.tabungan.isEmpty)
                  const Text('Anda belum memiliki rekening tabungan untuk tujuan pencairan.', style: TextStyle(color: Colors.red))
                else
                  DropdownButtonFormField<String>(
                    key: ValueKey('rek-tab-$_rekTab'),
                    initialValue: _rekTab,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Cairkan ke tabungan', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                    items: widget.tabungan.map((t) => DropdownMenuItem(value: t.noAcc, child: Text('${t.noAcc} - ${t.namaProduk}'))).toList(),
                    onChanged: (v) => setState(() => _rekTab = v),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _biru, foregroundColor: Colors.white),
                    onPressed: _submitting || widget.tabungan.isEmpty ? null : _submit,
                    child: _submitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Ajukan Penutupan'),
                  ),
                ),
              ],
            ),
    );
  }
}

// ============================ CETAK BILYET ============================

class CetakBilyetPage extends StatefulWidget {
  final DepositoModel deposito;
  final DepositoDigitalInfo digitalInfo;
  const CetakBilyetPage({super.key, required this.deposito, required this.digitalInfo});

  @override
  State<CetakBilyetPage> createState() => _CetakBilyetPageState();
}

class _CetakBilyetPageState extends State<CetakBilyetPage> {
  late Future<_BilyetData> _future;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_BilyetData> _load() async {
    final users = await Pref().getUsers();
    final results = await Future.wait([
      DepositoRepository.getDetailDeposito(noRek: widget.deposito.noAcc, userlogin: users.usersId, bprId: users.bprId),
      DepositoDigitalRepository.getFormatBilyet(bprId: users.bprId),
    ]);
    final detail = results[0] as DepositoDetailModel;
    final format = results[1] as BilyetFormat;

    Uint8List? logo;
    final logoUrl = users.bprLogo.trim();
    if (logoUrl.startsWith('http')) {
      try {
        final r = await Dio().get<List<int>>(
          logoUrl,
          options: Options(responseType: ResponseType.bytes, receiveTimeout: const Duration(seconds: 6), sendTimeout: const Duration(seconds: 6)),
        );
        logo = Uint8List.fromList(r.data ?? []);
      } catch (_) {
        logo = null; // logo gagal diunduh (mis. CORS di web) -> bilyet tetap tampil tanpa logo
      }
    }

    final noBilyet = widget.digitalInfo.noBilyet.isNotEmpty ? widget.digitalInfo.noBilyet : detail.noBilyet;
    final values = <String, String>{
      'nomor_bilyet': noBilyet,
      'nomor_deposito': detail.noRek,
      'nama_nasabah': detail.nama,
      'nomor_cif': detail.nocif,
      'nominal_deposito': 'Rp ${FormatCurrency.oCcy.format(detail.nominal)}',
      'terbilang': terbilangRupiah(detail.nominal),
      'rate_bunga': '${detail.rate.toStringAsFixed(2)} % p.a.',
      'tanggal_valuta': _fmtTanggal(detail.tglEff),
      'tanggal_jatuh_tempo': _fmtTanggal(detail.tglJatuhTempo),
      'nama_produk': widget.deposito.namaProduk,
      'nama_kantor': users.bprNama,
    };

    return _BilyetData(
      format: format,
      values: values,
      noBilyet: noBilyet,
      qrData: '$noBilyet|${detail.noRek}|${users.bprId}',
      penandatangan: users.bprNama,
      logo: logo,
    );
  }

  /// PDF dibuat hanya saat dibutuhkan (cetak/unduh), supaya pratinjau tidak bergantung pada PDF.js di browser.
  Future<Uint8List> _pdf(_BilyetData d) => buildBilyetPdf(format: d.format, values: d.values, qrData: d.qrData, penandatangan: d.penandatangan, logoBytes: d.logo);

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      debugPrint('ERROR BILYET PDF: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuat PDF bilyet. Silakan coba lagi.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(title: const Text('Bilyet Digital'), backgroundColor: _biru, foregroundColor: Colors.white),
      body: FutureBuilder<_BilyetData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) {
            debugPrint('ERROR BILYET: ${snap.error}');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(snap.error.toString().replaceFirst('Exception: ', ''), textAlign: TextAlign.center),
              ),
            );
          }
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: BilyetPreview(format: d.format, values: d.values, qrData: d.qrData, penandatangan: d.penandatangan, logo: d.logo),
                ),
              ),
              const SizedBox(height: 8),
              Text('Bilyet ${d.noBilyet} • ${d.format.lebarMm.toStringAsFixed(0)} x ${d.format.tinggiMm.toStringAsFixed(0)} mm', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : () => _run(() async => Printing.sharePdf(bytes: await _pdf(d), filename: 'Bilyet_${d.noBilyet}.pdf')),
                      icon: const Icon(Icons.download),
                      label: const Text('Unduh PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: _biru, foregroundColor: Colors.white),
                      onPressed: _busy
                          ? null
                          : () => _run(() async {
                              final bytes = await _pdf(d);
                              await Printing.layoutPdf(name: 'Bilyet_${d.noBilyet}', format: bilyetPageFormat(d.format), onLayout: (_) async => bytes);
                            }),
                      icon: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.print),
                      label: const Text('Cetak'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BilyetData {
  final BilyetFormat format;
  final Map<String, String> values;
  final String noBilyet;
  final String qrData;
  final String penandatangan;
  final Uint8List? logo;
  const _BilyetData({required this.format, required this.values, required this.noBilyet, required this.qrData, required this.penandatangan, required this.logo});
}

/// Pratinjau bilyet yang digambar langsung oleh Flutter (tanpa PDF.js), dengan posisi field dalam mm sesuai format CMS.
class BilyetPreview extends StatelessWidget {
  final BilyetFormat format;
  final Map<String, String> values;
  final String qrData;
  final String penandatangan;
  final Uint8List? logo;

  const BilyetPreview({super.key, required this.format, required this.values, required this.qrData, required this.penandatangan, this.logo});

  @override
  Widget build(BuildContext context) {
    final bg = decodeBilyetDataUri(format.bgBilyet);

    return AspectRatio(
      aspectRatio: format.lebarMm / format.tinggiMm,
      child: LayoutBuilder(
        builder: (context, c) {
          final mm = c.maxWidth / format.lebarMm; // piksel per mm
          final fontPx = format.fontSize * 0.3528 * mm; // 1 pt = 0.3528 mm

          double widthFor(double x) {
            final next = x < 90 ? 90.0 : (x < 140 ? 140.0 : format.lebarMm);
            return (next - x - 3).clamp(15.0, format.lebarMm).toDouble();
          }

          Widget fieldWidget(BilyetField f) {
            switch (f.key) {
              case 'logo':
                return logo == null ? const SizedBox() : SizedBox(width: 16 * mm, height: 16 * mm, child: Image.memory(logo!, fit: BoxFit.contain, errorBuilder: (_, _, _) => const SizedBox()));
              case 'qr_code':
                return QrImageView(data: qrData, size: 18 * mm, padding: EdgeInsets.zero, backgroundColor: Colors.white);
              case 'tanda_tangan':
                return SizedBox(
                  width: 40 * mm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10 * mm),
                      Container(height: 0.6, color: Colors.black87),
                      Text(penandatangan, style: TextStyle(fontSize: fontPx * 0.7, color: Colors.black87)),
                    ],
                  ),
                );
              default:
                return SizedBox(
                  width: widthFor(f.x) * mm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.label, style: TextStyle(fontSize: fontPx * 0.7, color: Colors.grey.shade700, height: 1.1)),
                      Text(values[f.key] ?? '-', style: TextStyle(fontSize: fontPx, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1)),
                    ],
                  ),
                );
            }
          }

          return Container(
            color: Colors.white,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                if (bg != null) Positioned.fill(child: Opacity(opacity: (format.bgOpacity / 100).clamp(0.0, 1.0), child: Image.memory(bg, fit: BoxFit.fill, errorBuilder: (_, _, _) => const SizedBox()))),
                for (final f in format.fields) Positioned(left: f.x * mm, top: f.y * mm, child: fieldWidget(f)),
              ],
            ),
          );
        },
      ),
    );
  }
}
