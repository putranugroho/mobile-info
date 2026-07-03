import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/module/deposit_opening/deposit_opening_notifier.dart';
import 'package:mobile_info/utils/format_currency.dart';
import 'package:provider/provider.dart';

class RupiahThousandsInputFormatter extends TextInputFormatter {
  const RupiahThousandsInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));

    final buffer = StringBuffer();
    int counter = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      counter++;
      buffer.write(digits[i]);
      if (counter % 3 == 0 && i != 0) buffer.write('.');
    }

    final formatted = buffer.toString().split('').reversed.join();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DepositOpeningPage extends StatefulWidget {
  const DepositOpeningPage({super.key});

  @override
  State<DepositOpeningPage> createState() => _DepositOpeningPageState();
}

class _DepositOpeningPageState extends State<DepositOpeningPage> {
  int selectedTab = 0;
  final tabs = const ["History Permohonan", "Permohonan Baru"];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepositOpeningNotifier(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 250, 250),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 95, 0),
          foregroundColor: Colors.white,
          title: const Text("Permohonan Buka Deposito", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        body: Consumer<DepositOpeningNotifier>(
          builder: (context, value, child) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(value),
                    _tabBar(),
                    Expanded(child: selectedTab == 0 ? _historyTab(value) : _formTab(context, value)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(DepositOpeningNotifier value) {
    final blocked = value.hasOngoingApplication;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 95, 0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ajukan dan pantau deposito",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Pantau status permohonan buka deposito",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!blocked) ...[
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() => selectedTab = 1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "Buka Deposito",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 95, 0)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final active = selectedTab == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => setState(() => selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))] : [],
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _historyTab(DepositOpeningNotifier value) {
    if (value.historyLoading) return const Center(child: CircularProgressIndicator());

    if (value.historyList.isEmpty) {
      return RefreshIndicator(
        onRefresh: value.loadHistory,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _historyCard(
              title: "Belum ada permohonan",
              amount: "Data permohonan belum tersedia",
              tenor: "-",
              status: "Info",
              statusColor: Colors.blue,
              desc: value.historyMessage.isNotEmpty ? value.historyMessage : "Riwayat permohonan buka deposito akan tampil di sini.",
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: value.loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.historyList.length,
        itemBuilder: (context, index) {
          final item = value.historyList[index];
          return _historyCard(
            title: item.namaRekening.isNotEmpty ? item.namaRekening : "Permohonan Deposito #${item.id}",
            amount: "Rp ${DepositNominalHelper.format(item.nominal)}",
            tenor: "${item.jangkaWaktu} bulan • ${item.sukuBunga}%",
            status: _depositStatusLabel(item.status),
            statusColor: _depositStatusColor(item.status),
            desc:
                "Rek. Debet ${item.rekeningDebet}"
                "${item.pencairanBunga.isNotEmpty ? "\nBunga: ${item.pencairanBunga}" : ""}"
                "${item.alasan.isNotEmpty ? "\n${item.alasan}" : ""}",
          );
        },
      ),
    );
  }

  Widget _historyCard({
    required String title,
    required String amount,
    required String tenor,
    required String status,
    required Color statusColor,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(tenor, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  String _depositStatusLabel(String status) {
    switch (status) {
      case "0":
        return "Diajukan";
      case "1":
        return "Dalam Peninjauan";
      case "2":
        return "Dapat Diproses";
      case "3":
        return "Belum Dapat Diproses";
      default:
        return "Diajukan";
    }
  }

  Color _depositStatusColor(String status) {
    switch (status) {
      case "0":
        return Colors.blueGrey;
      case "1":
        return Colors.blue;
      case "2":
        return Colors.green;
      case "3":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _formTab(BuildContext context, DepositOpeningNotifier value) {
    return RefreshIndicator(
      onRefresh: value.refreshAll,
      color: const Color.fromARGB(255, 0, 95, 0),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _infoCard(value),
          const SizedBox(height: 14),
          if (value.hasOngoingApplication) ...[
            _ongoingApplicationCard(value),
            const SizedBox(height: 24),
          ] else ...[
            _formCard(context, value),
            const SizedBox(height: 18),
            _processButton(context, value),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _ongoingApplicationCard(DepositOpeningNotifier value) {
    final item = value.ongoingApplication;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.hourglass_top_rounded, color: Colors.orange.shade800, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Permohonan sedang diproses",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Form detail data deposito disembunyikan sampai permohonan yang sedang berjalan selesai diproses.",
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item != null) ...[
            const SizedBox(height: 12),
            Divider(color: Colors.orange.shade200),
            const SizedBox(height: 8),
            _infoRow("Status", _depositStatusLabel(item.status)),
            _infoRow("Nominal", "Rp ${DepositNominalHelper.format(item.nominal)}"),
            _infoRow("Jangka Waktu", "${item.jangkaWaktu} bulan"),
            _infoRow("Rekening Debet", item.rekeningDebet.isNotEmpty ? item.rekeningDebet : "-"),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(DepositOpeningNotifier value) {
    final isActive = value.setupActive;
    final isLoading = value.setupLoading || value.rateLoading;
    final bgColor = isLoading
        ? Colors.blue.shade50
        : isActive
        ? Colors.green.shade50
        : Colors.orange.shade50;
    final borderColor = isLoading
        ? Colors.blue.shade200
        : isActive
        ? Colors.green.shade200
        : Colors.orange.shade200;
    final iconColor = isLoading
        ? Colors.blue.shade800
        : isActive
        ? Colors.green.shade800
        : Colors.orange.shade800;
    final message = isLoading
        ? "Sedang mengecek layanan dan rate produk deposito."
        : value.setupMessage.isNotEmpty
        ? value.setupMessage
        : "Lengkapi detail deposito, kirim OTP, lalu permohonan akan diteruskan untuk proses persetujuan.";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isActive ? Icons.check_circle_outline : Icons.info_outline, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 12, color: iconColor)),
          ),
        ],
      ),
    );
  }

  Widget _formCard(BuildContext context, DepositOpeningNotifier value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Detail Data Deposito", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _productDropdown(value),
          const SizedBox(height: 12),
          _readonlyField(label: "Suku Bunga", value: value.selectedRate > 0 ? "${value.selectedRate.toStringAsFixed(2)} %" : "-"),
          const SizedBox(height: 12),
          _nominalField(value),
          const SizedBox(height: 12),
          value.loading
              ? const Center(
                  child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
                )
              : _debetDropdown(value),
          const SizedBox(height: 12),
          _readonlyField(label: "Nama Rek", value: value.namaRekening),
          const SizedBox(height: 12),
          _interestDropdown(value),
          if (value.bayarBungaKeTabungan) ...[
            const SizedBox(height: 12),
            _interestAccountDropdown(value),
            const SizedBox(height: 12),
            _readonlyField(label: "Nama", value: value.namaRekening),
          ],
          const SizedBox(height: 12),
          _rollOverSelector(value),
          if (value.otpSent) ...[const SizedBox(height: 18), _otpCard(value)],
          if (value.errorMessage.isNotEmpty) ...[const SizedBox(height: 14), _errorCard(value.errorMessage)],
        ],
      ),
    );
  }

  Widget _productDropdown(DepositOpeningNotifier value) {
    if (value.rateLoading)
      return const Center(
        child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
      );
    if (value.productOptions.isEmpty) return _emptyAccountBox(value.rateMessage.isNotEmpty ? value.rateMessage : "Produk deposito belum tersedia.");

    return DropdownButtonFormField<DepositProductOption>(
      value: value.selectedProduct,
      isExpanded: true,
      decoration: _inputDecoration("Jangka Waktu"),
      items: value.productOptions.map((item) {
        return DropdownMenuItem<DepositProductOption>(value: item, child: Text("${item.jangkaWaktu} - ${item.namaProduk}"));
      }).toList(),
      onChanged: value.setProduct,
    );
  }

  Widget _nominalField(DepositOpeningNotifier value) {
    return TextField(
      controller: value.nominalController,
      keyboardType: TextInputType.number,
      inputFormatters: const [RupiahThousandsInputFormatter()],
      onChanged: (text) => value.setNominal(text.replaceAll(RegExp(r'[^0-9]'), '')),
      decoration: _inputDecoration("Nominal", helperText: "Kelipatan Rp 1.000.000", prefixText: "Rp "),
    );
  }

  Widget _debetDropdown(DepositOpeningNotifier value) {
    final accounts = value.eligibleDebetAccounts;
    final currentValue = accounts.any((item) => item.noAcc == value.selectedDebetNoRek) ? value.selectedDebetNoRek : null;
    if (accounts.isEmpty) return _emptyAccountBox("Tidak ada rekening tabungan dengan saldo lebih besar dari nominal deposito.");

    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      itemHeight: 64,
      menuMaxHeight: 320,
      decoration: _inputDecoration("Debet Rek"),
      selectedItemBuilder: (context) => accounts.map((item) => _accountSelectedItem(item)).toList(),
      items: accounts.map((item) => _accountDropdownItem(item)).toList(),
      onChanged: value.setDebetNoRek,
    );
  }

  Widget _interestDropdown(DepositOpeningNotifier value) {
    return DropdownButtonFormField<String>(
      value: value.selectedInterestCode,
      isExpanded: true,
      decoration: _inputDecoration("Bayar Bunga"),
      items: value.interestOptions.map((item) => DropdownMenuItem<String>(value: item.code, child: Text(item.label))).toList(),
      onChanged: value.setInterestCode,
    );
  }

  Widget _interestAccountDropdown(DepositOpeningNotifier value) {
    final accounts = value.listTabungan;
    final currentValue = accounts.any((item) => item.noAcc == value.selectedInterestNoRek) ? value.selectedInterestNoRek : null;
    if (accounts.isEmpty) return _emptyAccountBox("Rekening tujuan bunga belum tersedia.");

    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      itemHeight: 64,
      menuMaxHeight: 320,
      decoration: _inputDecoration("No Rek"),
      selectedItemBuilder: (context) => accounts.map((item) => _accountSelectedItem(item)).toList(),
      items: accounts.map((item) => _accountDropdownItem(item)).toList(),
      onChanged: value.setInterestNoRek,
    );
  }

  Widget _accountSelectedItem(TabunganModel item) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        item.noAcc,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  DropdownMenuItem<String> _accountDropdownItem(TabunganModel item) {
    return DropdownMenuItem<String>(
      value: item.noAcc,
      child: SizedBox(
        height: 58,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.noAcc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                "${item.namaProduk} • Saldo Rp ${FormatCurrency.oCcy.format(item.saldo)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rollOverSelector(DepositOpeningNotifier value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Roll Over",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _toggleButton(label: "Y", active: value.rollOver, onTap: () => value.setRollOver(true)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _toggleButton(label: "N", active: !value.rollOver, onTap: () => value.setRollOver(false)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _toggleButton({required String label, required bool active, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 0, 95, 0) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? const Color.fromARGB(255, 0, 95, 0) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _otpCard(DepositOpeningNotifier value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Input OTP", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Masukkan kode OTP yang dikirim ke nomor ${value.maskedPhone}.", style: TextStyle(fontSize: 12, color: Colors.green.shade900)),
          const SizedBox(height: 8),
          TextField(
            controller: value.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration("OTP", counterText: ""),
          ),
        ],
      ),
    );
  }

  Widget _processButton(BuildContext context, DepositOpeningNotifier value) {
    final isBusy = value.loading || value.setupLoading || value.rateLoading || value.historyLoading;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 95, 0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isBusy
            ? null
            : () async {
                final message = await value.process();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                if (value.requestSuccess) _showSuccessDialog(context, value);
              },
        child: Text(
          isBusy
              ? "Memproses..."
              : value.otpSent
              ? "Verifikasi OTP"
              : "Proses",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, DepositOpeningNotifier value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Berhasil"),
        content: const Text("Sukses, permintaan pembukaan deposito berhasil didaftarkan."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 95, 0), foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(dialogContext);
              value.resetAfterSuccess();
              await value.loadHistory();
              if (!mounted) return;
              setState(() => selectedTab = 0);
            },
            child: const Text("Lihat History"),
          ),
        ],
      ),
    );
  }

  Widget _readonlyField({required String label, required String value}) {
    return InputDecorator(
      decoration: _inputDecoration(label),
      child: Text(value.isNotEmpty ? value : "-", style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _emptyAccountBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text(message, style: TextStyle(fontSize: 12, color: Colors.red.shade800)),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 12, color: Colors.red.shade800)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? helperText, String? prefixText, String? counterText}) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      prefixText: prefixText,
      counterText: counterText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 95, 0)),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
    );
  }
}
