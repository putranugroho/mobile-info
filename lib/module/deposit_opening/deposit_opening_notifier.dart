import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/module/repository/deposit_opening_repository.dart';
import 'package:mobile_info/module/repository/rekening_repository.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';

class DepositNominalHelper {
  static final NumberFormat _formatter = NumberFormat("#,###", "id_ID");

  static String onlyDigits(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  static int parseInt(String value) => int.tryParse(onlyDigits(value)) ?? 0;

  static String format(dynamic value) {
    final clean = onlyDigits('$value');
    if (clean.isEmpty) return "0";
    final number = int.tryParse(clean) ?? 0;
    return _formatter.format(number).replaceAll(',', '.');
  }
}

class DepositProductOption {
  final String kodeProduk;
  final String namaProduk;
  final String jangkaWaktu;
  final int tenorBulan;
  final double rate;

  const DepositProductOption({
    required this.kodeProduk,
    required this.namaProduk,
    required this.jangkaWaktu,
    required this.tenorBulan,
    required this.rate,
  });

  factory DepositProductOption.fromRateProduct(Map<String, dynamic> json) {
    final namaProduk = '${json['nama_prd'] ?? json['nama_produk'] ?? json['namaProduk'] ?? json['nama'] ?? ''}'.trim();
    final kodeProduk = '${json['kode_prd'] ?? json['kode_produk'] ?? json['kodeProduk'] ?? json['kode'] ?? namaProduk}'.trim();
    final tenor = _parseTenor(json, namaProduk);
    final rate = _parseRate(json['rate'] ?? json['suku_bunga'] ?? json['sukuBunga'] ?? json['bunga']);

    return DepositProductOption(
      kodeProduk: kodeProduk.isNotEmpty ? kodeProduk : 'DEP-$tenor',
      namaProduk: namaProduk.isNotEmpty ? namaProduk : 'Deposito $tenor Bulan',
      jangkaWaktu: '$tenor Bulan',
      tenorBulan: tenor,
      rate: rate,
    );
  }

  static int _parseTenor(Map<String, dynamic> json, String fallbackText) {
    final candidates = [
      json['jangka_waktu'],
      json['jk_waktu'],
      json['jkwaktu'],
      json['tenor'],
      json['tenor_bulan'],
      json['bulan'],
      json['jangkaWaktu'],
      fallbackText,
    ];

    for (final item in candidates) {
      final text = '${item ?? ''}'.trim();
      if (text.isEmpty) continue;
      final direct = int.tryParse(text);
      if (direct != null && direct > 0) return direct;
      final match = RegExp(r'(\d+)').firstMatch(text);
      if (match != null) {
        final value = int.tryParse(match.group(1) ?? '');
        if (value != null && value > 0) return value;
      }
    }

    return 0;
  }

  static double _parseRate(dynamic value) {
    final text = '${value ?? ''}'.trim().replaceAll(',', '.');
    return double.tryParse(text) ?? 0;
  }
}

class InterestPaymentOption {
  final String code;
  final String label;
  final String apiValue;

  const InterestPaymentOption({required this.code, required this.label, required this.apiValue});
}

class DepositOpeningHistoryModel {
  final int id;
  final String aro;
  final String alasan;
  final String jangkaWaktu;
  final String namaRekening;
  final String namaTabunganBunga;
  final String noCif;
  final String noTabunganBunga;
  final String nominal;
  final String pencairanBunga;
  final String rekeningDebet;
  final String status;
  final String sukuBunga;
  final String tglInput;
  final String tglKeputusan;
  final String tglUbah;
  final String userHandle;

  const DepositOpeningHistoryModel({
    required this.id,
    required this.aro,
    required this.alasan,
    required this.jangkaWaktu,
    required this.namaRekening,
    required this.namaTabunganBunga,
    required this.noCif,
    required this.noTabunganBunga,
    required this.nominal,
    required this.pencairanBunga,
    required this.rekeningDebet,
    required this.status,
    required this.sukuBunga,
    required this.tglInput,
    required this.tglKeputusan,
    required this.tglUbah,
    required this.userHandle,
  });

  factory DepositOpeningHistoryModel.fromJson(Map<String, dynamic> json) {
    return DepositOpeningHistoryModel(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      aro: '${json['aro'] ?? ''}',
      alasan: '${json['alasan'] ?? ''}',
      jangkaWaktu: '${json['jangka_waktu'] ?? '0'}',
      namaRekening: '${json['nama_rekening'] ?? ''}',
      namaTabunganBunga: '${json['nama_tabungan_bunga'] ?? ''}',
      noCif: '${json['no_cif'] ?? ''}',
      noTabunganBunga: '${json['no_tabungan_bunga'] ?? ''}',
      nominal: '${json['nominal'] ?? '0'}',
      pencairanBunga: '${json['pencairan_bunga'] ?? ''}',
      rekeningDebet: '${json['rekening_debet'] ?? ''}',
      status: '${json['status'] ?? ''}',
      sukuBunga: '${json['suku_bunga'] ?? ''}',
      tglInput: '${json['tgl_input'] ?? ''}',
      tglKeputusan: '${json['tgl_keputusan'] ?? ''}',
      tglUbah: '${json['tgl_ubah'] ?? ''}',
      userHandle: '${json['user_handle'] ?? ''}',
    );
  }

  bool get statusFinal => status == '2' || status == '3';

  bool get masihDiproses => !statusFinal;
}

class DepositOpeningNotifier extends ChangeNotifier {
  DepositOpeningNotifier() {
    init();
  }

  UsersModel? users;

  bool loading = false;
  bool setupLoading = false;
  bool setupActive = false;
  bool rateLoading = false;
  bool historyLoading = false;
  bool otpSent = false;
  bool requestSuccess = false;

  String errorMessage = "";
  String setupMessage = "";
  String rateMessage = "";
  String historyMessage = "";
  String notificationMessage = "";
  String otpPhoneNumber = "";

  final nominalController = TextEditingController();
  final otpController = TextEditingController();

  List<DepositProductOption> productOptions = [];

  final List<InterestPaymentOption> interestOptions = const [
    InterestPaymentOption(code: "TAB", label: "Ke Tabungan", apiValue: "tabungan"),
    InterestPaymentOption(code: "TAMBAH_NOMINAL", label: "Tambah Nominal", apiValue: "tambah_nominal"),
    InterestPaymentOption(code: "TUNAI", label: "Tunai", apiValue: "tunai"),
  ];

  List<TabunganModel> listTabungan = [];
  List<DepositOpeningHistoryModel> historyList = [];

  DepositProductOption? selectedProduct;
  String? selectedDebetNoRek;
  String? selectedInterestCode;
  String? selectedInterestNoRek;
  bool rollOver = true;

  bool get isBusy => loading || setupLoading || rateLoading || historyLoading;

  bool get hasOngoingApplication => historyList.any((item) => item.masihDiproses);

  DepositOpeningHistoryModel? get ongoingApplication {
    for (final item in historyList) {
      if (item.masihDiproses) return item;
    }
    return null;
  }

  int get nominalValue => DepositNominalHelper.parseInt(nominalController.text);

  double get selectedRate => selectedProduct?.rate ?? 0;

  String get selectedJangkaWaktu => selectedProduct?.jangkaWaktu ?? "";

  String get namaRekening => users?.nama ?? "-";

  bool get bayarBungaKeTabungan => selectedInterestCode == "TAB";

  String get maskedPhone {
    final phone = otpPhoneNumber.isNotEmpty ? otpPhoneNumber : (users?.nomorPonsel ?? '');
    if (phone.length <= 4) return phone;
    return "${phone.substring(0, phone.length - 4).replaceAll(RegExp(r'[0-9]'), '*')}${phone.substring(phone.length - 4)}";
  }

  List<TabunganModel> get eligibleDebetAccounts {
    final nominal = nominalValue;
    if (nominal <= 0) return listTabungan;
    return listTabungan.where((item) => item.saldo > nominal).toList();
  }

  TabunganModel? get selectedDebetAccount {
    if (selectedDebetNoRek == null) return null;
    for (final item in listTabungan) {
      if (item.noAcc == selectedDebetNoRek) return item;
    }
    return null;
  }

  TabunganModel? get selectedInterestAccount {
    if (selectedInterestNoRek == null) return null;
    for (final item in listTabungan) {
      if (item.noAcc == selectedInterestNoRek) return item;
    }
    return null;
  }

  InterestPaymentOption? get selectedInterestOption {
    if (selectedInterestCode == null) return null;
    for (final item in interestOptions) {
      if (item.code == selectedInterestCode) return item;
    }
    return null;
  }

  Future<void> init() async {
    users = await Pref().getUsers();
    selectedInterestCode = interestOptions.first.code;

    await Future.wait([loadSetupPembukaanDeposito(), loadRateProduk(), loadTabungan(), loadHistory()]);

    notifyListeners();
  }

  Future<void> refreshAll() async {
    await Future.wait([loadSetupPembukaanDeposito(), loadRateProduk(), loadTabungan(), loadHistory()]);
  }

  Future<void> loadSetupPembukaanDeposito() async {
    setupLoading = true;
    setupActive = false;
    setupMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      final setupList = await DepositOpeningRepository.inquirySetupPembukaanDep(bprId: currentUser.bprId);

      final activeSetup = setupList.where((item) {
        final statusPembukaan = '${item['status_pembukaan'] ?? ''}'.trim().toUpperCase();
        final status = '${item['status'] ?? ''}'.trim().toUpperCase();
        final deletedAt = '${item['deleted_at'] ?? ''}'.trim();
        return statusPembukaan == 'Y' && status == 'A' && deletedAt.isEmpty;
      }).toList();

      setupActive = activeSetup.isNotEmpty;
      setupMessage = setupActive
          ? "Layanan permohonan buka deposito tersedia."
          : "Layanan permohonan buka deposito belum aktif. Silakan hubungi BPR.";
    } catch (e) {
      setupActive = false;
      setupMessage = "Gagal mengecek setup pembukaan deposito.";
      debugPrint("ERROR SETUP PEMBUKAAN DEPOSITO: $e");
    }

    setupLoading = false;
    notifyListeners();
  }

  Future<void> loadRateProduk() async {
    rateLoading = true;
    rateMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      final rows = await DepositOpeningRepository.inquiryRateProduk(bprId: currentUser.bprId, userLogin: currentUser.username);

      final parsed = rows.map((item) => DepositProductOption.fromRateProduct(item)).where((item) => item.tenorBulan > 0 && item.rate > 0).toList()
        ..sort((a, b) => a.tenorBulan.compareTo(b.tenorBulan));

      productOptions = parsed;

      if (productOptions.isEmpty) {
        selectedProduct = null;
        rateMessage = "Produk deposito belum tersedia dari rate produk.";
      } else {
        final previousCode = selectedProduct?.kodeProduk;
        selectedProduct = productOptions.firstWhere((item) => item.kodeProduk == previousCode, orElse: () => productOptions.first);
        rateMessage = "Rate deposito berhasil dimuat.";
      }
    } catch (e) {
      productOptions = [];
      selectedProduct = null;
      rateMessage = "Gagal mengambil rate produk deposito.";
      debugPrint("ERROR RATE PRODUK DEPOSITO: $e");
    }

    rateLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    historyLoading = true;
    historyMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      final rows = await DepositOpeningRepository.inquiryHistoryPermohonanDeposito(bprId: currentUser.bprId, noCif: currentUser.noCif);
      historyList = rows.map((item) => DepositOpeningHistoryModel.fromJson(item)).toList();
    } catch (e) {
      historyList = [];
      historyMessage = "$e";
      debugPrint("ERROR HISTORY PEMBUKAAN DEPOSITO: $e");
    }

    historyLoading = false;
    notifyListeners();
  }

  Future<void> loadTabungan() async {
    loading = true;
    errorMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      listTabungan = await RekeningRepository.getTabungan(
        token: token,
        endpoint: NetworkURL.inquiryMasterData(),
        user_login: "admin",
        term: "WEB",
        bprId: currentUser.bprId,
        nocif: currentUser.noCif,
      );

      final eligible = eligibleDebetAccounts;
      if (selectedDebetNoRek == null && eligible.isNotEmpty) selectedDebetNoRek = eligible.first.noAcc;
      if (selectedInterestNoRek == null && listTabungan.isNotEmpty) selectedInterestNoRek = listTabungan.first.noAcc;
    } catch (e) {
      errorMessage = "Gagal mengambil rekening tabungan.";
      debugPrint("ERROR LOAD TABUNGAN PEMBUKAAN DEPOSITO: $e");
    }

    loading = false;
    notifyListeners();
  }

  void setProduct(DepositProductOption? value) {
    selectedProduct = value;
    _resetOtpState();
    notifyListeners();
  }

  void setNominal(String value) {
    _resetOtpState();
    final eligible = eligibleDebetAccounts;
    if (selectedDebetNoRek != null && !eligible.any((item) => item.noAcc == selectedDebetNoRek)) {
      selectedDebetNoRek = eligible.isNotEmpty ? eligible.first.noAcc : null;
    }
    notifyListeners();
  }

  void setDebetNoRek(String? value) {
    selectedDebetNoRek = value;
    _resetOtpState();
    notifyListeners();
  }

  void setInterestCode(String? value) {
    selectedInterestCode = value;
    _resetOtpState();
    if (bayarBungaKeTabungan && selectedInterestNoRek == null && listTabungan.isNotEmpty) {
      selectedInterestNoRek = listTabungan.first.noAcc;
    }
    notifyListeners();
  }

  void setInterestNoRek(String? value) {
    selectedInterestNoRek = value;
    _resetOtpState();
    notifyListeners();
  }

  void setRollOver(bool value) {
    rollOver = value;
    _resetOtpState();
    notifyListeners();
  }

  void _resetOtpState() {
    otpSent = false;
    requestSuccess = false;
    errorMessage = "";
    notificationMessage = "";
    otpController.clear();
  }

  String? validateForm() {
    if (setupLoading || rateLoading || historyLoading) return "Data masih dimuat. Silakan tunggu.";
    if (!setupActive) return setupMessage.isNotEmpty ? setupMessage : "Layanan permohonan buka deposito belum aktif.";
    if (hasOngoingApplication)
      return "Masih ada permohonan deposito yang belum selesai. Pengajuan baru bisa dibuat setelah status Selesai atau Dibatalkan.";
    if (productOptions.isEmpty || selectedProduct == null) return "Produk deposito belum tersedia dari rate produk.";

    final nominal = nominalValue;
    if (nominal <= 0) return "Nominal wajib diisi.";
    if (nominal < 500000) return "Nominal minimal Rp 500.000.";
    if (nominal % 500000 != 0) return "Nominal harus kelipatan Rp 500.000.";

    if (selectedDebetNoRek == null) return "Pilih rekening debet dengan saldo lebih besar dari nominal deposito.";

    final debet = selectedDebetAccount;
    if (debet == null) return "Rekening debet tidak valid.";
    if (debet.saldo <= nominal) return "Saldo rekening debet harus lebih besar dari nominal deposito.";

    if (selectedInterestCode == null) return "Pilih metode bayar bunga.";
    if (bayarBungaKeTabungan && selectedInterestNoRek == null) return "Pilih nomor rekening tujuan bunga.";

    final currentUser = users;
    if (currentUser == null || currentUser.id == 0) return "Data user tidak valid. Silakan login ulang.";
    if (currentUser.nomorPonsel.trim().isEmpty) return "Nomor HP user tidak tersedia untuk pengiriman OTP.";

    return null;
  }

  Future<String> process() async {
    errorMessage = "";
    notificationMessage = "";
    requestSuccess = false;

    final validation = validateForm();
    if (validation != null) {
      errorMessage = validation;
      notifyListeners();
      return validation;
    }

    if (!otpSent) return await _sendOtp();
    return await _verifyOtpAndSubmit();
  }

  Future<String> _sendOtp() async {
    loading = true;
    errorMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      final value = await DepositOpeningRepository.requestOtpDeposito(phoneNumber: currentUser.nomorPonsel.trim(), bprId: currentUser.bprId);
      final body = value is Map<String, dynamic> ? value : {};
      final success =
          body['value'] == 1 || '${body['code'] ?? ''}' == '000' || body['status'] == true || '${body['status'] ?? ''}'.toLowerCase() == 'success';

      if (!success) {
        final message = '${body['message'] ?? 'Gagal mengirim OTP.'}';
        errorMessage = message;
        loading = false;
        notifyListeners();
        return message;
      }

      otpPhoneNumber = '${body['phone'] ?? body['phone_number'] ?? body['data']?['phone_number'] ?? currentUser.nomorPonsel}'.trim();
      otpSent = true;
      otpController.clear();
      loading = false;
      notifyListeners();
      return "OTP berhasil dikirim ke nomor $maskedPhone.";
    } catch (e) {
      final message = "Gagal mengirim OTP. Silakan coba lagi.";
      errorMessage = message;
      loading = false;
      notifyListeners();
      debugPrint("ERROR KIRIM OTP PEMBUKAAN DEPOSITO: $e");
      return message;
    }
  }

  Future<String> _verifyOtpAndSubmit() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      errorMessage = "OTP wajib diisi.";
      notifyListeners();
      return errorMessage;
    }
    if (otp.length != 6) {
      errorMessage = "OTP harus 6 digit.";
      notifyListeners();
      return errorMessage;
    }

    loading = true;
    errorMessage = "";
    notifyListeners();

    try {
      final currentUser = users ?? await Pref().getUsers();
      final verifyValue = await AuthRepository.verifyOtp(
        token,
        NetworkURL.verifyOtp(),
        otpPhoneNumber.isNotEmpty ? otpPhoneNumber : currentUser.nomorPonsel.trim(),
        otp,
        bprId: currentUser.bprId,
      );

      final verifyBody = verifyValue is Map<String, dynamic> ? verifyValue : {};
      final otpValid =
          (verifyBody['status'] == true || '${verifyBody['status'] ?? ''}'.toLowerCase() == 'success') && '${verifyBody['code'] ?? ''}' == '000';
      if (!otpValid) {
        final message = '${verifyBody['message'] ?? 'OTP tidak valid.'}';
        errorMessage = message;
        loading = false;
        notifyListeners();
        return message;
      }

      final submitResponse = await _submitPermohonan();
      final submitMessage = '${submitResponse['message'] ?? 'Sukses, permintaan pembukaan deposito.'}';

      final notifResult = await DepositOpeningRepository.notifyDepositStaff(
        bprId: currentUser.bprId,
        nama: currentUser.nama,
        nominal: nominalValue,
        jangkaWaktu: selectedProduct?.tenorBulan ?? 0,
      );

      notificationMessage = "Notifikasi terkirim ke ${notifResult.successCount}/${notifResult.totalRecipient} staff.";
      final message = "$submitMessage $notificationMessage";

      requestSuccess = true;
      loading = false;
      notifyListeners();
      await loadHistory();
      return message;
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      errorMessage = message.isNotEmpty ? message : "Gagal memproses permohonan deposito.";
      loading = false;
      notifyListeners();
      debugPrint("ERROR VERIFY OTP / SUBMIT PEMBUKAAN DEPOSITO: $e");
      return errorMessage;
    }
  }

  Future<Map<String, dynamic>> _submitPermohonan() async {
    final currentUser = users ?? await Pref().getUsers();
    final interestOption = selectedInterestOption;
    final interestAccount = selectedInterestAccount;

    final pencairanBunga = interestOption?.apiValue ?? "tabungan";
    final noTabunganBunga = bayarBungaKeTabungan ? (selectedInterestNoRek ?? '') : '';
    final namaTabunganBunga = bayarBungaKeTabungan && interestAccount != null ? currentUser.nama : '';

    return await DepositOpeningRepository.daftarPermohonanPembukaanDeposito(
      bprId: currentUser.bprId,
      noCif: currentUser.noCif,
      jangkaWaktu: selectedProduct?.tenorBulan ?? 0,
      sukuBunga: selectedProduct?.rate ?? 0,
      nominal: nominalValue,
      rekeningDebet: selectedDebetNoRek ?? '',
      namaRekening: currentUser.nama,
      pencairanBunga: pencairanBunga,
      noTabunganBunga: noTabunganBunga,
      namaTabunganBunga: namaTabunganBunga,
      aro: rollOver ? "Y" : "N",
      userLogin: currentUser.username.isNotEmpty ? currentUser.username : "SYSTEM",
    );
  }

  void resetAfterSuccess() {
    nominalController.clear();
    otpController.clear();
    selectedProduct = productOptions.isNotEmpty ? productOptions.first : null;
    selectedDebetNoRek = eligibleDebetAccounts.isNotEmpty ? eligibleDebetAccounts.first.noAcc : null;
    selectedInterestCode = interestOptions.first.code;
    selectedInterestNoRek = listTabungan.isNotEmpty ? listTabungan.first.noAcc : null;
    rollOver = true;
    otpSent = false;
    requestSuccess = false;
    errorMessage = "";
    notificationMessage = "";
    otpPhoneNumber = "";
    notifyListeners();
  }

  @override
  void dispose() {
    nominalController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
