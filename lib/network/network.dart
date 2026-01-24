const token = "715f8ab555438f985b579844ea227767";
const xusername = "core@2023";
const xpassword = "corevalue@20231234";
const url = "https://infoservices.medtrans.id";
const upload = "https://infoservices.medtrans.id/upload";
const photo = "https://infoservices.medtrans.id/photo";

class NetworkURL {
  static String login() {
    return "$url/webServices/login_info.php";
  }

  static String listBpr() {
    return "$url/webServices/get_list_bpr.php";
  }

  static String validasiKtp() {
    return "$url/webServices/validasi_medfo.php";
  }

  static String verifyOtp() {
    return "$url/webServices/verify_otp.php";
  }

  static String gantiPassword() {
    return "$url/webServices/ganti-password-mobile-info.php";
  }

  static String aktivasiAkun() {
    return "$url/webServices/aktivasi_akun_mobile_info.php";
  }

  static String generatedMpin() {
    return "$url/webServices/m_pin_generated.php";
  }

  static String inqueryMpin() {
    return "$url/inquery-mpin";
  }

  static String homeData() {
    return "$url/webServices/get_home_data.php";
  }

  static String getBankAccount() {
    return "$url/webServices/get_bank_accounts_.php";
  }

  static String queryBank() {
    return "$url/webServices/query_bank.php";
  }

  static String createQris() {
    return "$url/create-qris";
  }

  static String cekBalance() {
    return "$url/webServices/cek_saldo.php";
  }

  static String generatedToken() {
    return "$url/webServices/generated_token_.php";
  }

  static String getBank() {
    return "https://keeping.metimes.id/webServices/get_bank.php";
  }

  static String riwayat() {
    return "$url/webServices/get_history_token_.php";
  }

  static String denomisasi() {
    return "$url/webServices/get_denomisasi_tarik_tunai_.php";
  }

  static String transferOut() {
    return "$url/transfer-out";
  }

  static String prabayar() {
    return "$url/webServices/cek_prabayar.php";
  }

  static String checkBill() {
    return "$url/webServices/check_bill_iak.php";
  }

  static String prefix() {
    return "$url/webServices/get_prefix.php";
  }

  static String pascabayar() {
    return "$url/webServices/cek_pascabayar.php";
  }

  static String checkPostpaid() {
    return "$url/webServices/check_bill_postpaid.php";
  }

  static String streaming() {
    return "$url/streaming";
  }

  static String merchantIak() {
    return "$url/webServices/get_merchant.php";
  }

  static String getEToll() {
    return "$url/webServices/get_e_toll.php";
  }

  static String checkBillBPJS() {
    return "$url/webServices/check_bill_postpaid_bpjs.php";
  }

  static String gantiPhoto() {
    return "$url/webServices/ganti_photo.php";
  }

  static String lockScreen() {
    return "$url/webServices/lock_screen_.php";
  }

  static String getBankVA() {
    return "$url/webServices/get_bank_virtual_account.php";
  }

  static String transferIN() {
    return "$url/webServices/transfer_in_created.php";
  }

  static String inqueryRek() {
    return "$url/webServices/inquery_rek.php";
  }

  static String ppobIbpr() {
    return "$url/webServices/ppob_ibpr_.php";
  }

  static String ppobIbprPasca() {
    return "$url/webServices/ppob_ibpr_pasca_.php";
  }

  static String gantimpinIbpr() {
    return "$url/webServices/gantimpin_ibpr.php";
  }

  static String cekLupaPassword() {
    return "$url/webServices/cek_lupa_password.php";
  }

  static String updateLupaPassword() {
    return "$url/webServices/update_lupa_password_.php";
  }

  static String transferFlip() {
    return "$url/webServices/transfer_flip.php";
  }

  static String inquiryRekData() {
    return "$url/webServices/inquery_info_rek.php";
  }

  static String inquiryMasterData() {
    return "$url/webServices/inquery_info_masterdata.php";
  }

  static String inquiryMutasiTabungan() {
    return "$url/webServices/inquery_info_mutasitabungan.php";
  }

  static String inquiryDepositoData() {
    return "$url/webServices/inquery_info_deposito.php";
  }

  static String inquiryPinjamanData() {
    return "$url/webServices/inquery_info_pinjaman.php";
  }

  static String rateproduk() {
    return "$url/webServices/rate_produk.php";
  }
}
