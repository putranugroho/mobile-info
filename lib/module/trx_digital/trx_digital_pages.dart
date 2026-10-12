import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/models/trx_digital_model.dart';
import 'package:mobile_info/module/mutasi/mutasi_tabungan_page.dart';
import 'package:mobile_info/module/repository/trx_digital_repository.dart';
import 'package:mobile_info/utils/colors.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _jenisTarik = 'TARIK_TUNAI';
const _jenisSetor = 'SETOR_TUNAI';

/// Popup saat rekening tabungan diklik: Tarik Tunai, Setor Tunai, Mutasi Rekening.
void showTabunganActionSheet(BuildContext context, {required String noRekening, required String namaProduk}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) {
      Widget item(IconData icon, String title, String subtitle, VoidCallback onTap) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colorPrimary.withValues(alpha: 0.1),
            child: Icon(icon, color: colorPrimary),
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
              Text(namaProduk, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(noRekening, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              item(Icons.arrow_circle_up_outlined, 'Tarik Tunai', 'Buat QR untuk tarik tunai di teller', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrxDigitalFormPage(noRekening: noRekening, namaProduk: namaProduk, jenis: _jenisTarik),
                  ),
                );
              }),
              item(Icons.arrow_circle_down_outlined, 'Setor Tunai', 'Buat QR untuk setor tunai di teller', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrxDigitalFormPage(noRekening: noRekening, namaProduk: namaProduk, jenis: _jenisSetor),
                  ),
                );
              }),
              item(Icons.receipt_long_outlined, 'Mutasi Rekening', 'Lihat riwayat mutasi tabungan', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MutasiTabunganPage(noRekening: noRekening, namaProduk: namaProduk),
                  ),
                );
              }),
              item(Icons.qr_code_2, 'Riwayat QR Transaksi', 'QR yang masih aktif dapat ditampilkan lagi', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrxDigitalHistoryPage(noRekening: noRekening)),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

// ============================ FORM NOMINAL + MPIN ============================

class TrxDigitalFormPage extends StatefulWidget {
  final String noRekening;
  final String namaProduk;
  final String jenis;

  const TrxDigitalFormPage({super.key, required this.noRekening, required this.namaProduk, required this.jenis});

  @override
  State<TrxDigitalFormPage> createState() => _TrxDigitalFormPageState();
}

class _TrxDigitalFormPageState extends State<TrxDigitalFormPage> {
  final _nominalCtrl = TextEditingController();
  TrxDigitalSetupModel? _setup;
  String? _setupError;
  bool _loading = true;
  bool _submitting = false;

  bool get _isTarik => widget.jenis == _jenisTarik;
  String get _title => _isTarik ? 'Tarik Tunai' : 'Setor Tunai';

  @override
  void initState() {
    super.initState();
    _loadSetup();
  }

  @override
  void dispose() {
    _nominalCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSetup() async {
    try {
      final list = await TrxDigitalRepository.getSetup();
      final match = list.where((e) => e.jenis == widget.jenis);
      setState(() {
        _setup = match.isEmpty ? null : match.first;
        _setupError = match.isEmpty ? '$_title digital belum tersedia untuk BPR Anda' : null;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _setupError = e.toString();
        _loading = false;
      });
    }
  }

  double get _nominal => double.tryParse(_nominalCtrl.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;

  Future<void> _next() async {
    final setup = _setup!;
    final nominal = _nominal;
    if (nominal <= 0) return _snack('Masukkan nominal terlebih dahulu');
    if (nominal < setup.minNominal) return _snack('Minimal $_title Rp ${FormatCurrency.oCcy.format(setup.minNominal)}');
    if (setup.maxNominal > 0 && nominal > setup.maxNominal) {
      return _snack('Maksimal $_title Rp ${FormatCurrency.oCcy.format(setup.maxNominal)}');
    }

    final mpin = await _askMpin();
    if (mpin == null) return;

    setState(() => _submitting = true);
    try {
      final trx = await TrxDigitalRepository.create(noRek: widget.noRekening, jenis: widget.jenis, nominal: nominal, mpin: mpin);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TrxDigitalQrPage(trx: trx)));
    } on TrxDigitalException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      if (e.ibprNotActivated) {
        _showInfo('Akun IBPR belum aktif', 'Silakan aktifkan akun IBPR terlebih dahulu.');
      } else {
        _snack(e.message);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  Future<String?> _askMpin() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Masukkan MPIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_title Rp ${FormatCurrency.oCcy.format(_nominal)}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, letterSpacing: 8),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(counterText: '', hintText: '••••••', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: Colors.white),
            onPressed: () {
              if (ctrl.text.length < 6) return;
              Navigator.pop(ctx, ctrl.text);
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _showInfo(String title, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(title: Text(_title), backgroundColor: colorPrimary, foregroundColor: Colors.white),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _setupError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_setupError!, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: Text(widget.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(widget.noRekening),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nominalCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, _ThousandsFormatter()],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp ',
                    helperText:
                        'Minimal Rp ${FormatCurrency.oCcy.format(_setup!.minNominal)}'
                        '${_setup!.maxNominal > 0 ? ' • Maksimal Rp ${FormatCurrency.oCcy.format(_setup!.maxNominal)}' : ''}',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text('QR berlaku ${_setup!.durasiMenit} menit setelah dibuat.', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: Colors.white),
                    onPressed: _submitting ? null : _next,
                    child: _submitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Lanjutkan'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('.', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final formatted = FormatCurrency.oCcy.format(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ============================ QR ============================

class TrxDigitalQrPage extends StatefulWidget {
  final TrxDigitalModel trx;
  const TrxDigitalQrPage({super.key, required this.trx});

  @override
  State<TrxDigitalQrPage> createState() => _TrxDigitalQrPageState();
}

class _TrxDigitalQrPageState extends State<TrxDigitalQrPage> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final left = widget.trx.expiredAt.difference(DateTime.now());
    setState(() => _remaining = left.isNegative ? Duration.zero : left);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trx = widget.trx;
    final expired = _remaining == Duration.zero;
    final mm = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(title: Text('QR ${trx.jenisLabel}'), backgroundColor: colorPrimary, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(trx.jenisLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Rp ${FormatCurrency.oCcy.format(trx.nominal)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colorPrimary)),
                  const SizedBox(height: 16),
                  if (trx.qr.isNotEmpty && !expired)
                    QrImageView(data: trx.qr, size: 240, backgroundColor: Colors.white)
                  else
                    const SizedBox(
                      height: 240,
                      child: Center(
                        child: Text('QR sudah kedaluwarsa', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(expired ? 'Kedaluwarsa' : 'Berlaku $mm:$ss', style: TextStyle(fontWeight: FontWeight.w600, color: expired ? Colors.red : Colors.green.shade700)),
                  const Divider(height: 28),
                  _row('No. Rekening', trx.noRek),
                  _row('Nama', trx.nama),
                  _row('ID Transaksi', trx.trxId),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Tunjukkan QR ini kepada teller. QR hanya dapat digunakan satu kali dan dapat dibuka kembali dari Riwayat QR Transaksi selama masih berlaku.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 12),
        Flexible(child: Text(v, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    ),
  );
}

// ============================ HISTORY ============================

class TrxDigitalHistoryPage extends StatefulWidget {
  final String? noRekening;
  const TrxDigitalHistoryPage({super.key, this.noRekening});

  @override
  State<TrxDigitalHistoryPage> createState() => _TrxDigitalHistoryPageState();
}

class _TrxDigitalHistoryPageState extends State<TrxDigitalHistoryPage> {
  late Future<List<TrxDigitalModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = TrxDigitalRepository.history(noRek: widget.noRekening);
  }

  void _reload() => setState(() => _future = TrxDigitalRepository.history(noRek: widget.noRekening));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(title: const Text('Riwayat QR Transaksi'), backgroundColor: colorPrimary, foregroundColor: Colors.white),
      body: FutureBuilder<List<TrxDigitalModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text(snap.error.toString()), TextButton(onPressed: _reload, child: const Text('Coba lagi'))],
              ),
            );
          }
          final list = snap.data ?? [];
          if (list.isEmpty) return const Center(child: Text('Belum ada transaksi'));
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final t = list[i];
                final st = t.effectiveStatus;
                final color = st == 'ACTIVE' ? Colors.green : (st == 'USED' ? Colors.blue : Colors.grey);
                final label = st == 'ACTIVE' ? 'Aktif' : (st == 'USED' ? 'Sudah digunakan' : (st == 'EXPIRED' ? 'Kedaluwarsa' : st));
                return Card(
                  child: ListTile(
                    leading: Icon(t.isTarik ? Icons.arrow_circle_up_outlined : Icons.arrow_circle_down_outlined, color: colorPrimary),
                    title: Text('${t.jenisLabel} • Rp ${FormatCurrency.oCcy.format(t.nominal)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${t.noRek}\n${t.createdAt.toString().substring(0, 16)}'),
                    isThreeLine: true,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    onTap: t.canShowQr ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => TrxDigitalQrPage(trx: t))) : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
