import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/models/tabungan_model.dart';
import 'package:mobile_info/module/repository/rekening_repository.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';

class DepositProductOption {
  final String kodeProduk;
  final String namaProduk;
  final String jangkaWaktu;
  final double rate;

  const DepositProductOption({required this.kodeProduk, required this.namaProduk, required this.jangkaWaktu, required this.rate});
}

class InterestPaymentOption {
  final String code;
  final String label;

  const InterestPaymentOption({required this.code, required this.label});
}

class DepositOpeningNotifier extends ChangeNotifier {
  DepositOpeningNotifier() {
    init();
  }

  UsersModel? users;
  bool loading = false;
  bool otpSent = false;
  bool requestSuccess = false;
  String errorMessage = "";
  String simulatedOtp = "123456";

  final nominalController = TextEditingController();
  final otpController = TextEditingController();

  final List<DepositProductOption> productOptions = const [
    DepositProductOption(kodeProduk: "DEP-01", namaProduk: "Deposito 1 Bulan", jangkaWaktu: "1 Bulan", rate: 3.50),
    DepositProductOption(kodeProduk: "DEP-03", namaProduk: "Deposito 3 Bulan", jangkaWaktu: "3 Bulan", rate: 4.00),
    DepositProductOption(kodeProduk: "DEP-06", namaProduk: "Deposito 6 Bulan", jangkaWaktu: "6 Bulan", rate: 4.25),
    DepositProductOption(kodeProduk: "DEP-12", namaProduk: "Deposito 12 Bulan", jangkaWaktu: "12 Bulan", rate: 4.50),
  ];

  final List<InterestPaymentOption> interestOptions = const [
    InterestPaymentOption(code: "TAB", label: "Ke Tabungan"),
    InterestPaymentOption(code: "TAMBAH_NOMINAL", label: "Tambah Nominal"),
    InterestPaymentOption(code: "TUNAI", label: "Tunai"),
  ];

  List<TabunganModel> listTabungan = [];
  DepositProductOption? selectedProduct;
  String? selectedDebetNoRek;
  String? selectedInterestCode;
  String? selectedInterestNoRek;
  bool rollOver = true;

  int get nominalValue => int.tryParse(nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  double get selectedRate => selectedProduct?.rate ?? 0;

  String get selectedJangkaWaktu => selectedProduct?.jangkaWaktu ?? "";

  String get namaRekening => users?.nama ?? "-";

  bool get bayarBungaKeTabungan => selectedInterestCode == "TAB";

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

  Future<void> init() async {
    users = await Pref().getUsers();
    selectedProduct = productOptions.first;
    selectedInterestCode = interestOptions.first.code;
    await loadTabungan();
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
      if (selectedDebetNoRek == null && eligible.isNotEmpty) {
        selectedDebetNoRek = eligible.first.noAcc;
      }
      if (selectedInterestNoRek == null && listTabungan.isNotEmpty) {
        selectedInterestNoRek = listTabungan.first.noAcc;
      }
    } catch (e) {
      errorMessage = "Gagal mengambil rekening tabungan. Data rekening dapat disambungkan setelah backend siap.";
      debugPrint("ERROR LOAD TABUNGAN PEMBUKAAN DEPOSITO: $e");
    }

    loading = false;
    notifyListeners();
  }

  void setProduct(DepositProductOption? value) {
    selectedProduct = value;
    errorMessage = "";
    notifyListeners();
  }

  void setNominal(String value) {
    errorMessage = "";

    final eligible = eligibleDebetAccounts;
    if (selectedDebetNoRek != null && !eligible.any((item) => item.noAcc == selectedDebetNoRek)) {
      selectedDebetNoRek = eligible.isNotEmpty ? eligible.first.noAcc : null;
    }

    notifyListeners();
  }

  void setDebetNoRek(String? value) {
    selectedDebetNoRek = value;
    errorMessage = "";
    notifyListeners();
  }

  void setInterestCode(String? value) {
    selectedInterestCode = value;
    errorMessage = "";
    notifyListeners();
  }

  void setInterestNoRek(String? value) {
    selectedInterestNoRek = value;
    errorMessage = "";
    notifyListeners();
  }

  void setRollOver(bool value) {
    rollOver = value;
    notifyListeners();
  }

  String? validateForm() {
    if (selectedProduct == null) return "Jangka waktu / produk deposito wajib dipilih.";

    final nominal = nominalValue;
    if (nominal <= 0) return "Nominal wajib diisi.";
    if (nominal < 1000000) return "Nominal minimal Rp 1.000.000.";
    if (nominal % 1000000 != 0) return "Nominal harus kelipatan Rp 1.000.000.";

    if (selectedDebetNoRek == null) return "Pilih rekening debet dengan saldo lebih besar dari nominal deposito.";

    final debet = selectedDebetAccount;
    if (debet == null) return "Rekening debet tidak valid.";
    if (debet.saldo <= nominal) return "Saldo rekening debet harus lebih besar dari nominal deposito.";

    if (selectedInterestCode == null) return "Pilih metode bayar bunga.";
    if (bayarBungaKeTabungan && selectedInterestNoRek == null) return "Pilih nomor rekening tujuan bunga.";

    return null;
  }

  Future<String> process() async {
    errorMessage = "";

    final validation = validateForm();
    if (validation != null) {
      errorMessage = validation;
      notifyListeners();
      return validation;
    }

    if (!otpSent) {
      // TODO: ganti dengan endpoint kirim OTP setelah backend tersedia.
      otpSent = true;
      otpController.clear();
      notifyListeners();
      return "OTP berhasil dikirim. Untuk simulasi UI gunakan OTP $simulatedOtp.";
    }

    if (otpController.text.trim().isEmpty) {
      errorMessage = "OTP wajib diisi.";
      notifyListeners();
      return errorMessage;
    }

    if (otpController.text.trim() != simulatedOtp) {
      errorMessage = "OTP tidak cocok.";
      notifyListeners();
      return errorMessage;
    }

    // TODO: ganti dengan endpoint submit pembukaan deposito dan notifikasi pejabat.
    requestSuccess = true;
    notifyListeners();
    return "Sukses, permintaan pembukaan deposito.";
  }

  void resetAfterSuccess() {
    nominalController.clear();
    otpController.clear();
    selectedProduct = productOptions.first;
    selectedDebetNoRek = eligibleDebetAccounts.isNotEmpty ? eligibleDebetAccounts.first.noAcc : null;
    selectedInterestCode = interestOptions.first.code;
    selectedInterestNoRek = listTabungan.isNotEmpty ? listTabungan.first.noAcc : null;
    rollOver = true;
    otpSent = false;
    requestSuccess = false;
    errorMessage = "";
    notifyListeners();
  }

  @override
  void dispose() {
    nominalController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
