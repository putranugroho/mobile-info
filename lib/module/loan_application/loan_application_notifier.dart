import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_info/models/loan_application_model.dart';
import 'package:mobile_info/module/repository/loan_application_repository.dart';
import 'package:mobile_info/pref/pref.dart';

class LoanNominalHelper {
  static final NumberFormat _formatter = NumberFormat("#,###", "id_ID");

  static String onlyDigits(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static int parseInt(String value) {
    return int.tryParse(onlyDigits(value)) ?? 0;
  }

  static String format(String value) {
    final clean = onlyDigits(value);
    if (clean.isEmpty) return "";
    final number = int.tryParse(clean) ?? 0;
    return _formatter.format(number).replaceAll(",", ".");
  }
}

class LoanApplicationStatusNotifier extends ChangeNotifier {
  final BuildContext context;

  LoanApplicationStatusNotifier({required this.context}) {
    getStatusPengajuan();
  }

  bool loading = false;
  String errorMessage = "";
  List<LoanApplicationStatusModel> listStatus = [];

  Future<void> getStatusPengajuan() async {
    loading = true;
    errorMessage = "";
    notifyListeners();

    try {
      final users = await Pref().getUsers();

      listStatus = await LoanApplicationRepository.inquiryStatusPinjaman(bprId: users.bprId, nama: users.nama, noHp: users.nomorPonsel);
    } catch (e) {
      listStatus = [];
      errorMessage = "$e";
    }

    loading = false;
    notifyListeners();
  }
}

class LoanSimulationNotifier extends ChangeNotifier {
  final BuildContext context;

  LoanSimulationNotifier({required this.context}) {
    init();
  }

  final nilaiPinjamanController = TextEditingController();
  final jkWaktuController = TextEditingController();
  final rateController = TextEditingController();
  final cicilanController = TextEditingController();
  final totalController = TextEditingController();

  bool loadingSetup = true;
  bool setupAvailable = false;
  bool calculating = false;
  String setupMessage = "";

  int jkWaktuMin = 0;
  int jkWaktuMaks = 0;
  int? selectedJkWaktu;
  double sukuBunga = 0;

  List<int> get jkWaktuOptions {
    if (jkWaktuMin <= 0 || jkWaktuMaks <= 0) return [];
    return List.generate(jkWaktuMaks - jkWaktuMin + 1, (i) => jkWaktuMin + i);
  }

  Future<void> init() async {
    await inquirySetupSimulasi();
  }

  Future<void> inquirySetupSimulasi() async {
    loadingSetup = true;
    setupAvailable = false;
    setupMessage = "";
    notifyListeners();

    try {
      final users = await Pref().getUsers();
      final bprId = users.bprId;

      if (bprId.isEmpty) throw Exception("BPR ID tidak ditemukan.");

      final setup = await LoanApplicationRepository.inquirySetupPinjaman(bprId: bprId, flag: "");

      jkWaktuMin = setup.jkWaktuMin;
      jkWaktuMaks = setup.jkWaktuMaks;
      sukuBunga = setup.sukuBunga;

      selectedJkWaktu = jkWaktuMin;
      jkWaktuController.text = jkWaktuMin.toString();
      rateController.text = sukuBunga.toString();

      setupAvailable = true;
      setupMessage = "Layanan simulasi tersedia.";
    } catch (e) {
      setupAvailable = false;
      setupMessage = "$e";
    } finally {
      loadingSetup = false;
      notifyListeners();
    }
  }

  void setJkWaktu(int? value) {
    selectedJkWaktu = value;
    jkWaktuController.text = value?.toString() ?? "";
    clearResult();
  }

  void clearResult() {
    cicilanController.clear();
    totalController.clear();
    notifyListeners();
  }

  Future<void> hitungSimulasi() async {
    final nilai = LoanNominalHelper.parseInt(nilaiPinjamanController.text);
    final jk = int.tryParse(jkWaktuController.text) ?? 0;

    if (!setupAvailable) {
      _showSnack("Layanan simulasi belum tersedia.");
      return;
    }

    if (nilai <= 0) {
      _showSnack("Nilai pinjaman wajib diisi.");
      return;
    }

    if (jk < jkWaktuMin || jk > jkWaktuMaks) {
      _showSnack("Jangka waktu harus $jkWaktuMin - $jkWaktuMaks bulan.");
      return;
    }

    calculating = true;
    notifyListeners();

    try {
      final users = await Pref().getUsers();
      final result = await LoanApplicationRepository.simulasiTagihan(bprId: users.bprId, nilaiPinjaman: nilai, jangkaWaktu: jk, rate: sukuBunga);

      cicilanController.text = LoanNominalHelper.format(result.cicilan.toString());
      totalController.text = LoanNominalHelper.format(result.totalCicilan.toString());
    } catch (e) {
      _showSnack("Gagal menghitung simulasi: $e");
    } finally {
      calculating = false;
      notifyListeners();
    }
  }

  void _showSnack(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nilaiPinjamanController.dispose();
    jkWaktuController.dispose();
    rateController.dispose();
    cicilanController.dispose();
    totalController.dispose();
    super.dispose();
  }
}

class LoanApplicationNotifier extends ChangeNotifier {
  final BuildContext context;

  LoanApplicationNotifier({required this.context}) {
    init();
  }

  final formKey = GlobalKey<FormState>();
  final noCifController = TextEditingController();
  final noIdController = TextEditingController();
  final namaController = TextEditingController();
  final noHpController = TextEditingController();
  final alamatController = TextEditingController();
  final jaminanController = TextEditingController();
  final nilaiPinjamanController = TextEditingController();
  final jkWaktuController = TextEditingController();
  final rateController = TextEditingController();
  final cicilanController = TextEditingController();

  Uint8List? fotoJaminanBytes;
  String? fotoJaminanName;

  bool loadingSetup = true;
  bool setupAvailable = false;
  bool calculating = false;
  bool submitting = false;
  bool simulationDone = false;
  bool hideRateAndCicilan = false;

  String setupMessage = "";
  int jkWaktuMin = 0;
  int jkWaktuMaks = 0;
  double sukuBunga = 0;

  int? selectedJkWaktu;
  String? selectedJaminan;
  List<LoanJaminanModel> listJaminan = [];

  List<int> get jkWaktuOptions {
    if (jkWaktuMin <= 0 || jkWaktuMaks <= 0) return [];
    return List.generate(jkWaktuMaks - jkWaktuMin + 1, (index) => jkWaktuMin + index);
  }

  Future<void> init() async {
    await inquirySetupPinjaman();
  }

  Future<void> inquirySetupPinjaman() async {
    loadingSetup = true;
    setupAvailable = false;
    setupMessage = "";
    notifyListeners();

    try {
      final users = await Pref().getUsers();
      final bprId = users.bprId;

      if (bprId.isEmpty) throw Exception("BPR ID tidak ditemukan.");

      noCifController.text = users.noCif;
      noIdController.text = users.noIdentitas;
      namaController.text = users.nama;
      noHpController.text = users.nomorPonsel;

      final setup = await LoanApplicationRepository.inquirySetupPinjaman(bprId: bprId, flag: "1");

      final jaminan = await LoanApplicationRepository.inquiryJaminanAll(bprId: bprId);

      jkWaktuMin = setup.jkWaktuMin;
      jkWaktuMaks = setup.jkWaktuMaks;
      sukuBunga = setup.sukuBunga;
      hideRateAndCicilan = sukuBunga <= 0;

      if (hideRateAndCicilan) {
        rateController.clear();
        cicilanController.clear();
        simulationDone = true;
      } else {
        rateController.text = sukuBunga.toString();
        cicilanController.clear();
        simulationDone = false;
      }

      selectedJkWaktu = jkWaktuMin;
      jkWaktuController.text = jkWaktuMin.toString();

      listJaminan = jaminan;
      if (listJaminan.isNotEmpty) {
        selectedJaminan = listJaminan.first.kdJaminan;
        jaminanController.text = selectedJaminan ?? "";
      }

      setupAvailable = true;
      setupMessage = "Layanan pengajuan pinjaman tersedia.";
    } catch (e) {
      setupAvailable = false;
      setupMessage = "$e";
    } finally {
      loadingSetup = false;
      notifyListeners();
    }
  }

  void setJkWaktu(int? value) {
    selectedJkWaktu = value;
    jkWaktuController.text = value?.toString() ?? "";
    markSimulationDirty();
  }

  void setJaminan(String? value) {
    selectedJaminan = value;
    jaminanController.text = value ?? "";
    notifyListeners();
  }

  void markSimulationDirty() {
    if (!hideRateAndCicilan) {
      simulationDone = false;
      cicilanController.clear();
    }
    notifyListeners();
  }

  String? requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) return "$label wajib diisi";
    return null;
  }

  String? validateNoCif(String? value) {
    final text = value?.trim() ?? "";
    if (text.isEmpty) return "No CIF wajib diisi";
    return null;
  }

  String? validateNoId(String? value) {
    final text = value?.trim() ?? "";
    if (text.isEmpty) return "No Identitas wajib diisi";
    if (int.tryParse(text) == null) return "No Identitas harus angka";
    if (text.length < 8) return "No Identitas terlalu pendek";
    return null;
  }

  String? validateNoHp(String? value) {
    final text = value?.trim() ?? "";
    if (text.isEmpty) return "No HP wajib diisi";
    if (int.tryParse(text) == null) return "No HP harus angka";
    if (text.length < 10 || text.length > 14) return "No HP harus 10-14 digit";
    return null;
  }

  String? validateNumber(String? value, String label) {
    final text = value?.trim() ?? "";
    if (text.isEmpty) return "$label wajib diisi";

    final number = LoanNominalHelper.parseInt(text);
    if (number <= 0) return "$label harus angka lebih dari 0";

    return null;
  }

  String? validateJangkaWaktu(String? value) {
    final base = validateNumber(value, "Jangka Waktu");
    if (base != null) return base;

    final bulan = int.tryParse(value ?? "") ?? 0;
    if (bulan < jkWaktuMin || bulan > jkWaktuMaks) {
      return "Jangka waktu harus $jkWaktuMin - $jkWaktuMaks bulan";
    }

    return null;
  }

  static const double _jaminanMaxWidth = 1600;
  static const double _jaminanMaxHeight = 1600;
  static const int _jaminanImageQuality = 75;
  static const int _maxFotoJaminanBytes = 5 * 1024 * 1024;

  Future<XFile?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    return picker.pickImage(
      source: source,
      imageQuality: _jaminanImageQuality,
      maxWidth: _jaminanMaxWidth,
      maxHeight: _jaminanMaxHeight,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  Future<void> pickFotoJaminan() async {
    await _pickFotoJaminan(source: ImageSource.camera);
  }

  Future<void> pickFotoJaminanFromGallery() async {
    await _pickFotoJaminan(source: ImageSource.gallery);
  }

  Future<void> _pickFotoJaminan({required ImageSource source}) async {
    try {
      final result = await _pickImage(source);
      if (result == null) return;

      await _setFotoJaminan(result, source: source);
    } catch (e) {
      debugPrint("ERROR PICK FOTO JAMINAN ${source.name}: $e");

      if (kIsWeb && source == ImageSource.camera) {
        _showSnack("Kamera tidak tersedia di browser ini. Silakan pilih gambar dari galeri/file.");
        await _fallbackPickFotoJaminanFromGallery();
        return;
      }

      _showSnack(
        source == ImageSource.camera ? "Gagal membuka kamera. Pastikan izin kamera sudah diberikan." : "Gagal memilih gambar. Silakan coba lagi.",
      );
    }
  }

  Future<void> _fallbackPickFotoJaminanFromGallery() async {
    try {
      final result = await _pickImage(ImageSource.gallery);
      if (result == null) return;

      await _setFotoJaminan(result, source: ImageSource.gallery);
    } catch (e) {
      debugPrint("ERROR FALLBACK FOTO JAMINAN GALLERY: $e");
      _showSnack("Gagal memilih gambar dari galeri/file. Silakan coba lagi.");
    }
  }

  Future<void> _setFotoJaminan(XFile result, {required ImageSource source}) async {
    final bytes = await result.readAsBytes();

    if (bytes.isEmpty) {
      _showSnack("File foto jaminan kosong. Silakan pilih ulang gambar.");
      return;
    }

    if (bytes.length > _maxFotoJaminanBytes) {
      _showSnack("Ukuran foto jaminan terlalu besar. Maksimal 5 MB.");
      return;
    }

    fotoJaminanBytes = bytes;
    fotoJaminanName = _safeFotoJaminanName(result, source: source);

    debugPrint("FOTO JAMINAN DIPILIH: $fotoJaminanName (${bytes.length} bytes), source=${source.name}, web=$kIsWeb");

    notifyListeners();
  }

  String _safeFotoJaminanName(XFile result, {required ImageSource source}) {
    final rawName = result.name.trim();
    final ext = _safeImageExtension(rawName);
    final generatedName = "jaminan_${DateTime.now().millisecondsSinceEpoch}.$ext";

    if (source == ImageSource.gallery && rawName.isNotEmpty && rawName.contains('.')) {
      return _sanitizeFileName(rawName);
    }

    if (kIsWeb && rawName.isNotEmpty && rawName.contains('.')) {
      return _sanitizeFileName(rawName);
    }

    return generatedName;
  }

  String _safeImageExtension(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.png')) return 'png';
    if (lower.endsWith('.webp')) return 'webp';
    if (lower.endsWith('.jpeg')) return 'jpg';
    if (lower.endsWith('.jpg')) return 'jpg';

    return 'jpg';
  }

  String _sanitizeFileName(String fileName) {
    final clean = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    if (clean.trim().isEmpty) return "jaminan_${DateTime.now().millisecondsSinceEpoch}.jpg";
    return clean;
  }

  Future<void> pilihSumberFotoJaminan() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Ambil dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickFotoJaminan();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Pilih dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickFotoJaminanFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> hitungCicilan() async {
    if (hideRateAndCicilan) return;

    final nilaiError = validateNumber(nilaiPinjamanController.text, "Nilai Pinjaman");
    final jkError = validateJangkaWaktu(jkWaktuController.text);

    if (nilaiError != null || jkError != null) {
      _showSnack(nilaiError ?? jkError ?? "Data simulasi belum valid.");
      return;
    }

    calculating = true;
    simulationDone = false;
    cicilanController.clear();
    notifyListeners();

    try {
      final result = await LoanApplicationRepository.simulasiTagihan(
        bprId: (await Pref().getUsers()).bprId,
        nilaiPinjaman: LoanNominalHelper.parseInt(nilaiPinjamanController.text),
        jangkaWaktu: int.tryParse(jkWaktuController.text) ?? 0,
        rate: sukuBunga,
      );

      cicilanController.text = LoanNominalHelper.format(result.cicilan.toString());
      simulationDone = true;
    } catch (e) {
      _showSnack("Gagal menghitung cicilan: $e");
    } finally {
      calculating = false;
      notifyListeners();
    }
  }

  String get fotoJaminanFileName => fotoJaminanName ?? "";

  LoanApplicationFormModel buildFormModel() {
    return LoanApplicationFormModel(
      noId: noIdController.text.trim(),
      noCif: noCifController.text.trim(),
      nama: namaController.text.trim(),
      noHp: noHpController.text.trim(),
      alamat: alamatController.text.trim(),
      jaminan: jaminanController.text.trim(),
      nilaiPinjaman: LoanNominalHelper.onlyDigits(nilaiPinjamanController.text),
      jkWaktu: jkWaktuController.text.trim(),
      rate: hideRateAndCicilan ? "" : rateController.text.trim().replaceAll(",", "."),
      cicilan: hideRateAndCicilan ? "" : LoanNominalHelper.onlyDigits(cicilanController.text),
      fotoJaminanBytes: fotoJaminanBytes,
      fotoJaminanName: fotoJaminanName,
    );
  }

  Future<void> submitApplication() async {
    if (!setupAvailable) {
      _showSnack("Layanan pengajuan pinjaman belum tersedia.");
      return;
    }

    if (!hideRateAndCicilan) {
      if (!simulationDone || cicilanController.text.trim().isEmpty) {
        _showSnack("Silakan klik tombol Hitung untuk mendapatkan cicilan terlebih dahulu.");
        return;
      }
    }

    if (fotoJaminanBytes == null || fotoJaminanBytes!.isEmpty) {
      _showSnack("Foto jaminan wajib diupload.");
      return;
    }

    if (hideRateAndCicilan) {
      rateController.clear();
      cicilanController.clear();
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    submitting = true;
    notifyListeners();

    try {
      final users = await Pref().getUsers();
      final bprId = users.bprId;

      if (bprId.isEmpty) throw Exception("BPR ID tidak ditemukan.");

      if (noCifController.text.trim().isEmpty) {
        throw Exception("No CIF tidak ditemukan.");
      }

      final form = buildFormModel();

      await LoanApplicationRepository.submitLoanApplication(bprId: bprId, form: form);

      final notifResult = await LoanApplicationRepository.notifyLoanStaff(bprId: bprId, form: form);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Permohonan berhasil dikirim. Notifikasi terkirim ke ${notifResult.successCount}/${notifResult.totalRecipient} staff."),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      _showSnack("Gagal mengirim permohonan: $e");
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  void _showSnack(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    noCifController.dispose();
    noIdController.dispose();
    namaController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    jaminanController.dispose();
    nilaiPinjamanController.dispose();
    jkWaktuController.dispose();
    rateController.dispose();
    cicilanController.dispose();
    super.dispose();
  }
}
