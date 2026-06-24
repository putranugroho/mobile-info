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

    if (digits.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    final buffer = StringBuffer();
    int counter = 0;

    for (int i = digits.length - 1; i >= 0; i--) {
      counter++;
      buffer.write(digits[i]);

      if (counter % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    final formatted = buffer.toString().split('').reversed.join();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DepositOpeningPage extends StatelessWidget {
  const DepositOpeningPage({super.key});

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
          title: const Text("Pembukaan Deposito", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        body: Consumer<DepositOpeningNotifier>(
          builder: (context, value, child) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: RefreshIndicator(
                  onRefresh: value.loadTabungan,
                  color: const Color.fromARGB(255, 0, 95, 0),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _headerCard(),
                      const SizedBox(height: 14),
                      _infoCard(),
                      const SizedBox(height: 14),
                      _formCard(context, value),
                      const SizedBox(height: 18),
                      _processButton(context, value),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 95, 0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
      ),
      child: const Row(
        children: [
          Icon(Icons.savings, color: Colors.white, size: 34),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Buka Deposito Baru",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text("Lengkapi data, proses OTP, lalu permintaan dikirim ke pejabat.", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade800, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Tampilan ini masih mode persiapan UI. Kirim OTP, submit pembukaan deposito, dan notifikasi pejabat masih disimulasikan sampai backend tersedia.",
              style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
            ),
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
          const Text("Data Pembukaan Deposito", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
      onChanged: (text) {
        final rawNominal = text.replaceAll(RegExp(r'[^0-9]'), '');
        value.setNominal(rawNominal);
      },
      decoration: _inputDecoration("Nominal", helperText: "Kelipatan Rp 1.000.000", prefixText: "Rp "),
    );
  }

  Widget _debetDropdown(DepositOpeningNotifier value) {
    final accounts = value.eligibleDebetAccounts;
    final currentValue = accounts.any((item) => item.noAcc == value.selectedDebetNoRek) ? value.selectedDebetNoRek : null;

    if (accounts.isEmpty) {
      return _emptyAccountBox("Tidak ada rekening tabungan dengan saldo lebih besar dari nominal deposito.");
    }

    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      itemHeight: 64,
      menuMaxHeight: 320,
      decoration: _inputDecoration("Debet Rek"),
      selectedItemBuilder: (context) {
        return accounts.map((item) => _accountSelectedItem(item)).toList();
      },
      items: accounts.map((item) => _accountDropdownItem(item)).toList(),
      onChanged: value.setDebetNoRek,
    );
  }

  Widget _interestDropdown(DepositOpeningNotifier value) {
    return DropdownButtonFormField<String>(
      value: value.selectedInterestCode,
      isExpanded: true,
      decoration: _inputDecoration("Bayar Bunga"),
      items: value.interestOptions.map((item) {
        return DropdownMenuItem<String>(value: item.code, child: Text(item.label));
      }).toList(),
      onChanged: value.setInterestCode,
    );
  }

  Widget _interestAccountDropdown(DepositOpeningNotifier value) {
    final accounts = value.listTabungan;
    final currentValue = accounts.any((item) => item.noAcc == value.selectedInterestNoRek) ? value.selectedInterestNoRek : null;

    if (accounts.isEmpty) {
      return _emptyAccountBox("Rekening tujuan bunga belum tersedia.");
    }

    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      itemHeight: 64,
      menuMaxHeight: 320,
      decoration: _inputDecoration("No Rek"),
      selectedItemBuilder: (context) {
        return accounts.map((item) => _accountSelectedItem(item)).toList();
      },
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
          const SizedBox(height: 8),
          TextField(
            controller: value.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration("OTP", helperText: "Simulasi OTP: ${value.simulatedOtp}", counterText: ""),
          ),
        ],
      ),
    );
  }

  Widget _processButton(BuildContext context, DepositOpeningNotifier value) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 95, 0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: value.loading
            ? null
            : () async {
                final message = await value.process();
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

                if (value.requestSuccess) {
                  _showSuccessDialog(context, value);
                }
              },
        child: Text(value.otpSent ? "Verifikasi OTP" : "Proses", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, DepositOpeningNotifier value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Berhasil"),
          content: const Text("Sukses, permintaan pembukaan deposito. Notifikasi ke pejabat berhasil disiapkan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text("Kembali"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 95, 0), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(dialogContext);
                value.resetAfterSuccess();
              },
              child: const Text("Buat Lagi"),
            ),
          ],
        );
      },
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 95, 0)),
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
