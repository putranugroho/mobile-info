import 'package:flutter/material.dart';
import 'package:mobile_info/module/loan_application/loan_application_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  int selectedTab = 0;

  final tabs = ["Status Pengajuan", "Simulasi Pinjaman"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 250),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 95, 0),
        foregroundColor: Colors.white,
        title: const Text("Permohonan Pinjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ChangeNotifierProvider(
        create: (context) => LoanApplicationStatusNotifier(context: context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Consumer<LoanApplicationStatusNotifier>(
              builder: (context, statusValue, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(statusValue),
                    _tabBar(),
                    Expanded(child: selectedTab == 0 ? _pengajuanSaya(statusValue) : _simulasiKredit()),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(LoanApplicationStatusNotifier statusValue) {
    final bool isSubmittingLoan =
        statusValue.listStatus.isNotEmpty && (statusValue.listStatus.first.status == "0" || statusValue.listStatus.first.status == "1");
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
                  "Ajukan dan pantau pinjaman",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Pantau status pengajuan Anda",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: isSubmittingLoan
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (context) => LoanApplicationNotifier(context: context),
                          child: const LoanApplicationFormPage(),
                        ),
                      ),
                    ).then((_) {
                      statusValue.getStatusPengajuan();
                    });
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: isSubmittingLoan ? Colors.grey.shade300 : Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(
                isSubmittingLoan ? "Sedang Mengajukan" : "Ajukan Pinjaman",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSubmittingLoan ? Colors.grey.shade700 : const Color.fromARGB(255, 0, 95, 0),
                ),
              ),
            ),
          ),
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
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
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

  Widget _pengajuanSaya(LoanApplicationStatusNotifier value) {
    if (value.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (value.listStatus.isEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _statusCard(
            title: "Belum ada permohonan",
            amount: "Data pengajuan belum tersedia",
            tenor: "-",
            status: "Info",
            statusColor: Colors.blue,
            desc: value.errorMessage.isNotEmpty ? value.errorMessage : "Riwayat pengajuan pinjaman Anda akan tampil di sini.",
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: value.getStatusPengajuan,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.listStatus.length,
        itemBuilder: (context, index) {
          final item = value.listStatus[index];

          return _statusCard(
            title: item.nama,
            amount: "Rp ${LoanNominalHelper.format(item.nilaiPinjaman)}",
            tenor: "${item.jkWaktu} bulan",
            status: _loanStatusLabel(item.status),
            statusColor: _loanStatusColor(item.status),
            desc:
                "Cicilan per bulan Rp ${LoanNominalHelper.format(item.cicilanPerbulan)}"
                "${item.alasan.isNotEmpty ? "\n${item.alasan}" : ""}",
          );
        },
      ),
    );
  }

  Widget _statusCard({
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
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("$amount • $tenor", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  String _loanStatusLabel(String status) {
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

  Color _loanStatusColor(String status) {
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

  Widget _simulasiKredit() {
    return ChangeNotifierProvider(
      create: (context) => LoanSimulationNotifier(context: context),
      child: Consumer<LoanSimulationNotifier>(
        builder: (context, value, child) {
          if (value.loadingSetup) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!value.setupAvailable) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 42, color: Colors.orange),
                      const SizedBox(height: 12),
                      const Text("Simulasi Belum Tersedia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        "Layanan belum tersedia",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _sectionTitle("Simulasi Kredit"),
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.25)),
                ),
                child: Text(
                  "Jangka waktu tersedia ${value.jkWaktuMin} - ${value.jkWaktuMaks} bulan. Suku bunga ${value.sukuBunga}%.",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              _formInput(
                "Nilai Pinjaman",
                value.nilaiPinjamanController,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                onChanged: (_) => value.clearResult(),
              ),
              DropdownButtonFormField<int>(
                value: value.selectedJkWaktu,
                items: value.jkWaktuOptions.map((bulan) => DropdownMenuItem<int>(value: bulan, child: Text("$bulan bulan"))).toList(),
                onChanged: value.setJkWaktu,
                decoration: InputDecoration(
                  labelText: "Jangka Waktu",
                  helperText: "Minimal ${value.jkWaktuMin} bulan, maksimal ${value.jkWaktuMaks} bulan",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              _formInput("Suku Bunga (%)", value.rateController, keyboardType: const TextInputType.numberWithOptions(decimal: true), readOnly: true),
              ElevatedButton(
                onPressed: value.calculating ? null : value.hitungSimulasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: value.calculating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Hitung Simulasi", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Hasil Simulasi", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _resultRow("Cicilan / Bulan", value.cicilanController.text.isEmpty ? "-" : "Rp ${value.cicilanController.text}"),
                    _resultRow("Total Estimasi", value.totalController.text.isEmpty ? "-" : "Rp ${value.totalController.text}"),
                    const SizedBox(height: 8),
                    Text(
                      "* Simulasi hanya estimasi dan belum menjadi persetujuan kredit.",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  Widget _input(String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
    );
  }
}

class LoanApplicationFormPage extends StatelessWidget {
  const LoanApplicationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanApplicationNotifier>(
      builder: (context, value, child) {
        if (value.loadingSetup) {
          return const Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 250, 250),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!value.setupAvailable) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 250, 250),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 0, 95, 0),
              foregroundColor: Colors.white,
              title: const Text("Ajukan Pinjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(offset: const Offset(2, 2), blurRadius: 6, color: Colors.grey[300] ?? Colors.transparent)],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, size: 42, color: Colors.orange),
                        const SizedBox(height: 12),
                        const Text("Layanan Belum Tersedia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          value.setupMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: value.inquirySetupPinjaman, child: const Text("Tutup")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 250, 250),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 0, 95, 0),
            foregroundColor: Colors.white,
            title: const Text("Ajukan Pinjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: value.formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.25)),
                      ),
                      child: Text(
                        value.hideRateAndCicilan
                            ? "Jangka waktu tersedia ${value.jkWaktuMin} - ${value.jkWaktuMaks} bulan."
                            : "Jangka waktu tersedia ${value.jkWaktuMin} - ${value.jkWaktuMaks} bulan. Suku bunga ${value.sukuBunga}%.",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),

                    _formSectionTitle("Data Pemohon"),
                    _formInput("No CIF", value.noCifController, validator: value.validateNoCif, readOnly: true),
                    _formInput(
                      "No Identitas",
                      value.noIdController,
                      keyboardType: TextInputType.number,
                      validator: value.validateNoId,
                      readOnly: true,
                    ),
                    _formInput("Nama", value.namaController, validator: (v) => value.requiredValidator(v, "Nama"), readOnly: true),
                    _formInput("No HP", value.noHpController, keyboardType: TextInputType.phone, validator: value.validateNoHp, readOnly: true),
                    _formInput("Alamat", value.alamatController, maxLines: 2, validator: (v) => value.requiredValidator(v, "Alamat")),

                    const SizedBox(height: 12),
                    _formSectionTitle("Data Pinjaman"),

                    DropdownButtonFormField<String>(
                      value: value.selectedJaminan,
                      items: value.listJaminan.map((item) => DropdownMenuItem<String>(value: item.kdJaminan, child: Text(item.deskripsi))).toList(),
                      onChanged: value.setJaminan,
                      validator: (_) => value.requiredValidator(value.jaminanController.text, "Jaminan"),
                      decoration: InputDecoration(
                        labelText: "Jaminan",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _formInput(
                      "Nilai Pinjaman",
                      value.nilaiPinjamanController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [RupiahInputFormatter()],
                      validator: (v) => value.validateNumber(v, "Nilai Pinjaman"),
                      onChanged: (_) => value.markSimulationDirty(),
                    ),

                    DropdownButtonFormField<int>(
                      value: value.selectedJkWaktu,
                      items: value.jkWaktuOptions.map((bulan) => DropdownMenuItem<int>(value: bulan, child: Text("$bulan bulan"))).toList(),
                      onChanged: value.setJkWaktu,
                      validator: (_) => value.validateJangkaWaktu(value.jkWaktuController.text),
                      decoration: InputDecoration(
                        labelText: "Jangka Waktu",
                        helperText: "Minimal ${value.jkWaktuMin} bulan, maksimal ${value.jkWaktuMaks} bulan",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (!value.hideRateAndCicilan) ...[
                      _formInput(
                        "Rate (%)",
                        value.rateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        readOnly: true,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _formInput(
                              "Cicilan / Bulan",
                              value.cicilanController,
                              keyboardType: TextInputType.number,
                              validator: (v) => value.validateNumber(v, "Cicilan"),
                              readOnly: true,
                              helperText: "* Perhitungan hanya estimasi",
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: value.calculating ? null : value.hitungCicilan,
                              child: value.calculating
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text("Hitung"),
                            ),
                          ),
                        ],
                      ),
                    ],

                    _formUploadBox("Foto Jaminan", fileName: value.fotoJaminanFileName, onTap: value.pilihSumberFotoJaminan),

                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: value.submitting ? null : value.submitApplication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 95, 0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: value.submitting
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text("Ajukan Pinjaman", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _formSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 4),
    child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
  );
}

Widget _formInput(
  String label,
  TextEditingController controller, {
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool readOnly = false,
  String? helperText,
  ValueChanged<String>? onChanged,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

Widget _formUploadBox(String label, {required String fileName, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload_file, color: Color.fromARGB(255, 0, 95, 0)),
          const SizedBox(width: 10),
          Expanded(child: Text(fileName.isNotEmpty ? fileName : label, overflow: TextOverflow.ellipsis)),
          const Text(
            "Pilih File",
            style: TextStyle(color: Color.fromARGB(255, 0, 95, 0), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    final number = int.tryParse(digitsOnly) ?? 0;
    final formatted = _format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _format(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final positionFromEnd = text.length - i;
      buffer.write(text[i]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}
