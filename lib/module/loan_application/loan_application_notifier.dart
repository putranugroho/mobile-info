import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
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


class _NormalizedJaminanImage {
  final Uint8List bytes;
  final int originalWidth;
  final int originalHeight;
  final int width;
  final int height;
  final int quality;

  const _NormalizedJaminanImage({
    required this.bytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.width,
    required this.height,
    required this.quality,
  });
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
  String? fotoJaminanMimeType;
  String? fotoJaminanSource;
  int fotoJaminanSizeBytes = 0;

  int fotoJaminanOriginalSizeBytes = 0;
  int fotoJaminanOriginalWidth = 0;
  int fotoJaminanOriginalHeight = 0;
  int fotoJaminanNormalizedWidth = 0;
  int fotoJaminanNormalizedHeight = 0;
  int fotoJaminanCompressQuality = 0;

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

  static const double _pickerMaxWidth = 2200;
  static const double _pickerMaxHeight = 2200;
  static const int _pickerImageQuality = 85;

  /// Ukuran final yang dikirim ke backend/CMS.
  /// Dibuat lebih kecil dan konsisten agar file kamera HP tidak terlalu besar,
  /// EXIF kamera dibuang, dan CMS lebih aman membuka preview.
  static const int _jaminanNormalizedMaxSide = 1280;
  static const int _jaminanInitialJpegQuality = 72;
  static const int _jaminanMinJpegQuality = 45;
  static const int _maxFotoJaminanBytes = 1500 * 1024;

  Future<XFile?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    return picker.pickImage(
      source: source,
      imageQuality: _pickerImageQuality,
      maxWidth: _pickerMaxWidth,
      maxHeight: _pickerMaxHeight,
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
      if (result == null) {
        _debugFotoJaminan('USER_CANCEL_PICK', source: source);
        return;
      }

      await _setFotoJaminan(result, source: source);
    } catch (e, st) {
      debugPrint('ERROR PICK FOTO JAMINAN ${_sourceName(source)}: $e');
      debugPrint('$st');

      if (kIsWeb && source == ImageSource.camera) {
        _showSnack('Kamera tidak tersedia di browser ini. Silakan pilih gambar dari galeri/file.');
        await _fallbackPickFotoJaminanFromGallery();
        return;
      }

      _showSnack(source == ImageSource.camera
          ? 'Gagal membuka kamera. Pastikan izin kamera sudah diberikan.'
          : 'Gagal memilih gambar. Silakan coba lagi.');
    }
  }

  Future<void> _fallbackPickFotoJaminanFromGallery() async {
    try {
      final result = await _pickImage(ImageSource.gallery);
      if (result == null) {
        _debugFotoJaminan('USER_CANCEL_FALLBACK_GALLERY', source: ImageSource.gallery);
        return;
      }

      await _setFotoJaminan(result, source: ImageSource.gallery, fallbackFromCamera: true);
    } catch (e, st) {
      debugPrint('ERROR FALLBACK FOTO JAMINAN GALLERY: $e');
      debugPrint('$st');
      _showSnack('Gagal memilih gambar dari galeri/file. Silakan coba lagi.');
    }
  }

  Future<void> _setFotoJaminan(
    XFile result, {
    required ImageSource source,
    bool fallbackFromCamera = false,
  }) async {
    final originalBytes = await result.readAsBytes();

    if (originalBytes.isEmpty) {
      _showSnack('File foto jaminan kosong. Silakan pilih ulang gambar.');
      return;
    }

    final normalized = _normalizeFotoJaminan(originalBytes);
    if (normalized == null) {
      _showSnack('Format gambar tidak dapat diproses. Gunakan JPG atau PNG.');
      return;
    }

    if (normalized.bytes.length > _maxFotoJaminanBytes) {
      _showSnack('Ukuran foto jaminan masih terlalu besar setelah kompres. Silakan ambil ulang foto dengan jarak lebih dekat/pilih gambar lain.');
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    fotoJaminanBytes = normalized.bytes;
    fotoJaminanName = 'jaminan_${_sourceName(source)}_$timestamp.jpg';
    fotoJaminanMimeType = 'image/jpeg';
    fotoJaminanSource = fallbackFromCamera ? 'camera_fallback_gallery' : _sourceName(source);
    fotoJaminanSizeBytes = normalized.bytes.length;
    fotoJaminanOriginalSizeBytes = originalBytes.length;
    fotoJaminanOriginalWidth = normalized.originalWidth;
    fotoJaminanOriginalHeight = normalized.originalHeight;
    fotoJaminanNormalizedWidth = normalized.width;
    fotoJaminanNormalizedHeight = normalized.height;
    fotoJaminanCompressQuality = normalized.quality;

    _debugFotoJaminan(
      'FOTO_JAMINAN_SELECTED_AND_NORMALIZED',
      source: source,
      file: result,
      fallbackFromCamera: fallbackFromCamera,
    );

    notifyListeners();
  }

  _NormalizedJaminanImage? _normalizeFotoJaminan(Uint8List originalBytes) {
    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) return null;

    // Membaca orientation dari EXIF lalu membuang EXIF saat encode ulang JPEG.
    final oriented = img.bakeOrientation(decoded);
    final originalWidth = oriented.width;
    final originalHeight = oriented.height;

    img.Image output = oriented;
    final maxSide = originalWidth > originalHeight ? originalWidth : originalHeight;
    if (maxSide > _jaminanNormalizedMaxSide) {
      final scale = _jaminanNormalizedMaxSide / maxSide;
      final targetWidth = (originalWidth * scale).round().clamp(1, _jaminanNormalizedMaxSide).toInt();
      final targetHeight = (originalHeight * scale).round().clamp(1, _jaminanNormalizedMaxSide).toInt();

      output = img.copyResize(
        oriented,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );
    }

    var quality = _jaminanInitialJpegQuality;
    List<int> encoded = img.encodeJpg(output, quality: quality);

    while (encoded.length > _maxFotoJaminanBytes && quality > _jaminanMinJpegQuality) {
      quality -= 5;
      encoded = img.encodeJpg(output, quality: quality);
    }

    // Kalau masih besar, resize sekali lagi ke 1024px agar CMS aman membuka preview.
    if (encoded.length > _maxFotoJaminanBytes) {
      final secondMaxSide = 1024;
      final currentMaxSide = output.width > output.height ? output.width : output.height;
      if (currentMaxSide > secondMaxSide) {
        final scale = secondMaxSide / currentMaxSide;
        output = img.copyResize(
          output,
          width: (output.width * scale).round().clamp(1, secondMaxSide).toInt(),
          height: (output.height * scale).round().clamp(1, secondMaxSide).toInt(),
          interpolation: img.Interpolation.average,
        );
      }
      quality = _jaminanMinJpegQuality;
      encoded = img.encodeJpg(output, quality: quality);
    }

    return _NormalizedJaminanImage(
      bytes: Uint8List.fromList(encoded),
      originalWidth: originalWidth,
      originalHeight: originalHeight,
      width: output.width,
      height: output.height,
      quality: quality,
    );
  }

  String _sourceName(ImageSource source) {
    return source == ImageSource.camera ? 'camera' : 'gallery';
  }

  void _debugFotoJaminan(
    String tag, {
    required ImageSource source,
    XFile? file,
    bool fallbackFromCamera = false,
  }) {
    if (!kDebugMode) return;

    debugPrint('========== $tag ==========');
    debugPrint('platform_web          : $kIsWeb');
    debugPrint('requested_source      : ${_sourceName(source)}');
    debugPrint('fallback_from_camera  : $fallbackFromCamera');
    debugPrint('xfile.name            : ${file?.name}');
    debugPrint('xfile.path            : ${file?.path}');
    debugPrint('xfile.mimeType        : ${file?.mimeType}');
    debugPrint('original.sizeBytes    : $fotoJaminanOriginalSizeBytes');
    debugPrint('original.dimension    : ${fotoJaminanOriginalWidth}x$fotoJaminanOriginalHeight');
    debugPrint('normalized.filename   : $fotoJaminanName');
    debugPrint('normalized.mimeType   : $fotoJaminanMimeType');
    debugPrint('normalized.source     : $fotoJaminanSource');
    debugPrint('normalized.sizeBytes  : $fotoJaminanSizeBytes');
    debugPrint('normalized.dimension  : ${fotoJaminanNormalizedWidth}x$fotoJaminanNormalizedHeight');
    debugPrint('normalized.quality    : $fotoJaminanCompressQuality');
    debugPrint('multipart.field       : fhoto_jaminan');
    debugPrint('==============================');
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
      fotoJaminanMimeType: fotoJaminanMimeType,
      fotoJaminanSource: fotoJaminanSource,
      fotoJaminanSizeBytes: fotoJaminanSizeBytes,
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

      final submitResult = await LoanApplicationRepository.submitLoanApplication(bprId: bprId, form: form);

      if (LoanApplicationRepository.debugDryRunSubmit) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("DEBUG ONLY: payload berhasil dibentuk, tetapi tidak dikirim ke endpoint. Data tidak tersimpan."),
          ),
        );

        debugPrint("DRY RUN SUBMIT RESULT: $submitResult");
        return;
      }

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
