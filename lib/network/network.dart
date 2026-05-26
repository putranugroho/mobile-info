const token = "715f8ab555438f985b579844ea227767";
const xusername = "core@2023";
const xpassword = "corevalue@20231234";
const url = "https://infoservices.medtrans.id";
const url_medfo = "https://api-dev-medfo.medtrans.id";
const url_go = "https://api-dev-cms.medtrans.id";
const url_biz = "https://ibprbiz.medtrans.id";
const upload = "https://infoservices.medtrans.id/upload";
const photo = "https://infoservices.medtrans.id/photo";

class NetworkURL {
  static String login() {
    return "$url_biz/user-medfo-login";
  }

  static String listBpr() {
    return "$url/webServices/get_list_bpr.php";
  }

  static String validasiKtp() {
    return "$url_biz/user-medfo-aktivasi";
  }

  static String verifyOtp() {
    return "$url_biz/user-medfo-verify-otp";
  }

  static String gantiPassword() {
    return "$url_biz/webServices/ganti-password-mobile-info.php";
  }

  static String verifyOtpWebService() {
    return "$url_biz/webServices/verify_otp.php";
  }

  static String lupaSandiMedfo() {
    return "$url_biz/webServices/lupa_sandi_medfo.php";
  }

  static String updateSandiMedfo() {
    return "$url_biz/webServices/update_sandi_medfo.php";
  }

  static String updateProfileMedfo() {
    return "$url_biz/webServices/update_profile_medfo.php";
  }

  static String aktivasiAkun() {
    return "$url_biz/aktivasi-medfo";
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

  static String productData() {
    return "$url_medfo/inquiry/promosi-by-all";
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

  static String inquiryBalance() {
    return "$url_go/inquiry_balance";
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
    return "$url_medfo/inquiry/master-data";
  }

  static String inquiryMutasiTabungan() {
    return "$url_medfo/inquiry/mutasi-tabungan";
  }

  static String inquiryDepositoData() {
    return "$url_medfo/inquiry/detail-deposito";
  }

  static String inquiryPinjamanData() {
    return "$url_medfo/inquiry/tagihan-kredit";
  }

  static String rateproduk() {
    return "$url_medfo/inquiry/rate-produk";
  }

  static String publicBanner() {
    return "$url_go/banner/public";
  }

  static String bannerViewImage(String file) {
    return "$url_go/banner/view?type=image&file=$file";
  }

  static String bannerViewVideo(String file) {
    return "$url_go/banner/view?type=video&file=$file";
  }

  static String inquiryNotifikasiPinjaman() {
    return "$url_medfo/inquiry/notifikasi-pinjaman";
  }

  static String daftarPermohonanPinjaman() {
    return "$url_medfo/permohonan-pinjaman/daftar";
  }

  static String pushNotifPinjaman() {
    return "$url/webServices/push_notif.php";
  }

  static String inquirySetupPinjaman() {
    return "$url_medfo/inquiry/pinjaman";
  }

  static String simulasiTagihanPinjaman() {
    return "$url_medfo/simulasi-tagihan";
  }

  static String inquiryJaminanAll() {
    return "$url_medfo/inquiry/jaminan-all";
  }

  static String bprProfile() {
    return "$url_go/bpr_profile";
  }

  static String logoBprView(String file) {
    return "$url_go/photo/view?file=$file&type=logo_bpr";
  }

  static String splashBannerPublic() {
    return "$url_go/splash-banner/public";
  }

  static String inquiryPermohonanPinjaman() {
    return "$url_medfo/inquiry/permohonan-pinjaman";
  }

  static String logoutMedfo() {
    return "$url_biz/webServices/logout_medfo.php";
  }
}
