import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class DepositNotificationRecipientModel {
  final int id;
  final String cif;
  final String nama;
  final String noHp;
  final String status;

  const DepositNotificationRecipientModel({required this.id, required this.cif, required this.nama, required this.noHp, required this.status});

  factory DepositNotificationRecipientModel.fromJson(Map<String, dynamic> json) {
    return DepositNotificationRecipientModel(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      cif: "${json['cif'] ?? ''}",
      nama: "${json['nama'] ?? ''}",
      noHp: "${json['no_hp'] ?? ''}",
      status: "${json['status'] ?? ''}",
    );
  }
}

class DepositNotificationResultModel {
  final int totalRecipient;
  final int successCount;
  final int failedCount;

  const DepositNotificationResultModel({required this.totalRecipient, required this.successCount, required this.failedCount});
}

class DepositOpeningRepository {
  static dynamic _decode(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  static Dio _dio() {
    final dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';
    return dio;
  }

  static Future<Map<String, dynamic>> requestOtpDeposito({required String phoneNumber, required String bprId}) async {
    final body = {"phone_number": phoneNumber.trim(), "bpr_id": bprId.trim()};

    if (kDebugMode) {
      print("ENDPOINT REQUEST OTP DEPOSITO : ${NetworkURL.requestOtpDeposito()}");
      print("REQUEST OTP DEPOSITO : $body");
    }

    final response = await _dio().post(NetworkURL.requestOtpDeposito(), data: body);

    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE REQUEST OTP DEPOSITO : $res");
    }

    if (res is! Map<String, dynamic>) {
      throw Exception("Response request OTP deposito tidak valid.");
    }

    final code = '${res['code'] ?? ''}';
    final status = '${res['status'] ?? ''}'.toLowerCase();

    if (code != '000' && status != 'success' && res['status'] != true) {
      throw Exception(res['message'] ?? "Gagal mengirim OTP deposito.");
    }

    return res;
  }

  static Future<List<Map<String, dynamic>>> inquirySetupPembukaanDep({required String bprId}) async {
    final body = {
      "bpr_id": bprId,
      "user_login": "SYSTEM",
      "term": "web",
      "filter": {"status_pembukaan": "", "product_by": "", "jurnal": "", "nosbb": "", "namasbb": "", "status": "", "id": null},
      "sort": {"by": "id", "order": "DESC"},
      "pagination": {"page": 1, "limit": 100},
    };

    if (kDebugMode) {
      print("ENDPOINT INQUIRY SETUP PEMBUKAAN DEP : ${NetworkURL.inquiryPembukaanDep()}");
      print("REQUEST INQUIRY SETUP PEMBUKAAN DEP : $body");
    }

    final response = await _dio().post(NetworkURL.inquiryPembukaanDep(), data: body);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE INQUIRY SETUP PEMBUKAAN DEP : $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response setup pembukaan deposito tidak valid.");
    if ('${res['code'] ?? ''}' != '000') throw Exception(res['message'] ?? "Gagal mengambil setup pembukaan deposito.");

    final data = res['data'];
    if (data is Map<String, dynamic>) {
      final rows = data['data'];
      if (rows is List) return rows.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (data is List) return data.map((e) => Map<String, dynamic>.from(e)).toList();
    return [];
  }

  static Future<List<Map<String, dynamic>>> inquiryRateProduk({required String bprId, required String userLogin}) async {
    final body = {"bpr_id": bprId, "userlogin": userLogin.trim().isNotEmpty ? userLogin.trim() : "SYSTEM", "term": "WEB"};

    if (kDebugMode) {
      print("ENDPOINT RATE PRODUK : ${NetworkURL.rateproduk()}");
      print("REQUEST RATE PRODUK : $body");
    }

    final response = await _dio().post(NetworkURL.rateproduk(), data: body);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE RATE PRODUK : $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response rate produk tidak valid.");
    if ('${res['code'] ?? ''}' != '000') throw Exception(res['message'] ?? "Gagal mengambil rate produk deposito.");

    final data = res['data'];
    if (data is Map<String, dynamic>) {
      final rows = data['deposito'];
      if (rows is List) return rows.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return [];
  }

  static Future<List<Map<String, dynamic>>> inquiryHistoryPermohonanDeposito({required String bprId, required String noCif}) async {
    final body = {
      "bpr_id": bprId,
      "user_login": "SYSTEM",
      "term": "web",
      "filter": {"no_cif": noCif},
      "sort": {"by": "id", "order": "DESC"},
      "pagination": {"page": 1, "limit": 100},
    };

    if (kDebugMode) {
      print("ENDPOINT HISTORY PEMBUKAAN DEPOSITO : ${NetworkURL.inquiryPermohonanPembukaanDeposito()}");
      print("REQUEST HISTORY PEMBUKAAN DEPOSITO : $body");
    }

    final response = await _dio().post(NetworkURL.inquiryPermohonanPembukaanDeposito(), data: body);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE HISTORY PEMBUKAAN DEPOSITO : $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response history permohonan deposito tidak valid.");
    if ('${res['code'] ?? ''}' != '000') throw Exception(res['message'] ?? "Data history permohonan deposito tidak ditemukan.");

    final data = res['data'];
    if (data is Map<String, dynamic>) {
      final rows = data['data'];
      if (rows is List) return rows.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> daftarPermohonanPembukaanDeposito({
    required String bprId,
    required String noCif,
    required int jangkaWaktu,
    required double sukuBunga,
    required int nominal,
    required String rekeningDebet,
    required String namaRekening,
    required String pencairanBunga,
    required String noTabunganBunga,
    required String namaTabunganBunga,
    required String aro,
    required String userLogin,
  }) async {
    final body = {
      "bpr_id": bprId,
      "no_cif": noCif,
      "jangka_waktu": jangkaWaktu,
      "suku_bunga": sukuBunga,
      "nominal": nominal,
      "rekening_debet": rekeningDebet,
      "nama_rekening": namaRekening,
      "pencairan_bunga": pencairanBunga,
      "no_tabungan_bunga": noTabunganBunga,
      "nama_tabungan_bunga": namaTabunganBunga,
      "aro": aro,
      "user_login": userLogin.trim().isNotEmpty ? userLogin.trim() : "SYSTEM",
      "term": "web",
    };

    if (kDebugMode) {
      print("ENDPOINT DAFTAR PEMBUKAAN DEPOSITO : ${NetworkURL.daftarPembukaanDeposito()}");
      print("REQUEST DAFTAR PEMBUKAAN DEPOSITO : $body");
    }

    final response = await _dio().post(NetworkURL.daftarPembukaanDeposito(), data: body);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE DAFTAR PEMBUKAAN DEPOSITO : $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response permohonan pembukaan deposito tidak valid.");

    final code = '${res['code'] ?? ''}';
    final status = '${res['status'] ?? ''}'.toLowerCase();
    if (code != '000' && status != 'success') {
      throw Exception(res['message'] ?? "Gagal mendaftarkan permohonan pembukaan deposito.");
    }

    return res;
  }

  /// Ambil semua username Pejabat aktif (role_user = '1') DI KANTOR
  /// TERTENTU (kd_kantor), lewat inquiry data petugas -- SAMA PERSIS
  /// dengan cara CMS Medfo menentukan siapa yang dinotifikasi untuk
  /// pembukaan deposito (_getAllPejabatUsername di
  /// pembukaan_deposito_notifier.dart).
  ///
  /// RIWAYAT: sebelumnya penerima notif diambil lewat
  /// inquiryNotificationRecipients() yang memanggil endpoint
  /// /inquiry/notifikasi-pinjaman -- endpoint itu untuk fitur notifikasi
  /// PINJAMAN, bukan daftar Pejabat, jadi kemungkinan besar penerimanya
  /// tidak sinkron dengan siapa yang sebenarnya dinotifikasi CMS untuk
  /// deposito. Sekarang query-nya diganti supaya sumbernya benar-benar
  /// sama dengan CMS.
  ///
  /// PENTING: kd_kantor WAJIB diisi (sebelumnya '' -- menjangkau semua
  /// kantor di bpr yang sama, bukan cuma kantor nasabah pemohon). Sekarang
  /// difilter di request DAN di-double-check lagi di sisi client, supaya
  /// notif deposito nasabah kantor 001 tidak nyasar ke Pejabat kantor 002
  /// (atau BPR lain -- itu sudah otomatis aman karena bpr_id juga difilter).
  static Future<List<String>> _getAllPejabatUsername({
    required String bprId,
    required String kdKantor,
  }) async {
    final normalizedKantor = kdKantor.trim();
    if (normalizedKantor.isEmpty) {
      if (kDebugMode) {
        print("⚠️ _getAllPejabatUsername dipanggil tanpa kd_kantor -- dibatalkan supaya tidak notif ke semua kantor.");
      }
      return [];
    }

    final body = {
      "bpr_id": bprId,
      "filter": {
        "username": "",
        "nama": "",
        "no_hp": "",
        "kd_kantor": normalizedKantor,
        "no_identitas": "",
        "jabatan": "",
        "role_user": "1",
        "status": "",
        "status_aktif": "",
        "tgl_lahir_from": "",
        "tgl_lahir_to": "",
        "created_at_from": "",
        "created_at_to": "",
      },
      "sort": {"by": "created_at", "type": "desc"},
      "pagination": {"page": 1, "limit": 100},
    };

    if (kDebugMode) {
      print("ENDPOINT INQUIRY DATA PETUGAS (Pejabat) : ${NetworkURL.inquiryDataPetugasMedfo()}");
      print("REQUEST INQUIRY DATA PETUGAS (Pejabat) : $body");
    }

    try {
      final response = await _dio().post(NetworkURL.inquiryDataPetugasMedfo(), data: body);
      final res = _decode(response.data);

      if (kDebugMode) {
        print("RESPONSE INQUIRY DATA PETUGAS (Pejabat) : $res");
      }

      if (res is! Map<String, dynamic>) return [];
      if ('${res['code'] ?? ''}' != '000') return [];

      // Parsing defensif: bentuk `data` dari endpoint ini bisa berupa list
      // langsung, {data:[...]}, atau {items:[...]} -- sama seperti
      // web_service kita sendiri harus jaga-jaga soal ini juga.
      final data = res['data'];
      List<dynamic> rows = [];
      if (data is List) {
        rows = data;
      } else if (data is Map) {
        if (data['data'] is List) {
          rows = data['data'];
        } else if (data['items'] is List) {
          rows = data['items'];
        }
      }

      return rows
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) {
            final roleUser = '${e['role_user'] ?? ''}'.trim();
            final status = '${e['status'] ?? e['status_aktif'] ?? ''}'.trim().toUpperCase();
            final kantorRow = '${e['kd_kantor'] ?? ''}'.trim();
            return roleUser == '1' && status == 'A' && kantorRow == normalizedKantor;
          })
          .map((e) => '${e['username'] ?? ''}'.trim())
          .where((username) => username.isNotEmpty)
          .toList();
    } catch (e) {
      if (kDebugMode) print("ERROR INQUIRY DATA PETUGAS (Pejabat) : $e");
      return [];
    }
  }

  static Future<List<DepositNotificationRecipientModel>> inquiryNotificationRecipients({required String bprId}) async {
    final body = {"bpr_id": bprId, "user_login": "admin", "term": "WEB"};

    if (kDebugMode) {
      print("ENDPOINT INQUIRY NOTIFIKASI DEPOSITO : ${NetworkURL.inquiryNotifikasiPinjaman()}");
      print("REQUEST INQUIRY NOTIFIKASI DEPOSITO : $body");
    }

    final response = await _dio().post(NetworkURL.inquiryNotifikasiPinjaman(), data: body);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE INQUIRY NOTIFIKASI DEPOSITO : $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response inquiry notifikasi tidak valid.");
    if ('${res['code'] ?? ''}' != '000') throw Exception(res['message'] ?? "Gagal inquiry penerima notifikasi.");

    final data = res['data'];
    if (data is! List) return [];

    return data.map((e) => DepositNotificationRecipientModel.fromJson(Map<String, dynamic>.from(e))).where((e) => e.cif.trim().isNotEmpty).toList();
  }

  static Future<bool> sendPushNotification({required String title, required String body, required String bprId, required String noCif}) async {
    final payload = {"title": title, "bpr_id": bprId, "body": body, "no_cif": noCif};

    if (kDebugMode) {
      print("ENDPOINT PUSH NOTIFIKASI DEPOSITO : ${NetworkURL.pushNotifPinjaman()}");
      print("REQUEST PUSH NOTIFIKASI DEPOSITO : $payload");
    }

    final response = await _dio().post(NetworkURL.pushNotifPinjaman(), data: payload);
    final res = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE PUSH NOTIFIKASI DEPOSITO : $res");
    }

    return res is Map<String, dynamic> && (res['value'] == 1 || res['status'] == true || '${res['code'] ?? ''}' == '000');
  }

  /// Kirim notif ke semua Pejabat aktif saat ada pengajuan pembukaan
  /// deposito baru -- judul & isi pesan disamakan PERSIS dengan yang
  /// dipakai CMS Medfo untuk status 0 (lihat _depositoStatusBody di
  /// pembukaan_deposito_notifier.dart), supaya pesan yang diterima Pejabat
  /// konsisten baik pengajuan datang dari CMS maupun dari mobile-info ini.
  static Future<DepositNotificationResultModel> notifyDepositStaff({
    required String bprId,
    required String kdKantor,
    required String nama,
    required int nominal,
    required int jangkaWaktu,
  }) async {
    final pejabatUsernames = await _getAllPejabatUsername(bprId: bprId, kdKantor: kdKantor);
    if (pejabatUsernames.isEmpty) throw Exception("Pejabat aktif di kantor ini belum tersedia.");

    const title = "Pembukaan Deposito";
    final body = "Ada pengajuan pembukaan deposito baru atas nama $nama, menunggu diproses.";

    int successCount = 0;
    int failedCount = 0;

    for (final username in pejabatUsernames) {
      final success = await sendPushNotification(title: title, body: body, bprId: bprId, noCif: username);

      success ? successCount++ : failedCount++;
    }

    return DepositNotificationResultModel(totalRecipient: pejabatUsernames.length, successCount: successCount, failedCount: failedCount);
  }
}
