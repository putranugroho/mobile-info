import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/models/loan_application_model.dart';
import 'package:mobile_info/network/network.dart';

class LoanApplicationRepository {
  static Future<LoanSetupPinjamanModel> inquirySetupPinjaman({required String bprId, required String flag}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquirySetupPinjaman(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB", "flag": flag});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("INQUIRY SETUP PINJAMAN FLAG $flag RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) {
      throw Exception("Response setup pinjaman tidak valid.");
    }

    if (res['code'] != '000') {
      throw Exception(res['message'] ?? "Layanan pengajuan pinjaman belum tersedia.");
    }

    final data = res['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception("Data setup pinjaman tidak valid.");
    }

    return LoanSetupPinjamanModel.fromJson(data);
  }

  static Future<List<LoanJaminanModel>> inquiryJaminanAll({required String bprId}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquiryJaminanAll(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB"});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response jaminan tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal mengambil data jaminan.");

    final data = res['data'];
    if (data is! List) return [];

    return data.map((e) => LoanJaminanModel.fromJson(Map<String, dynamic>.from(e))).where((e) => e.status == "A" && e.kdJaminan.isNotEmpty).toList();
  }

  static Future<LoanSimulationResultModel> simulasiTagihan({required int nilaiPinjaman, required int jangkaWaktu, required double rate}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(
      NetworkURL.simulasiTagihanPinjaman(),
      data: {"nilai_pinjaman": nilaiPinjaman, "jangka_waktu": jangkaWaktu, "rate": rate, "jenis_rate": "F"},
    );

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response simulasi tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal menghitung simulasi pinjaman.");

    final data = res['data'];
    if (data is! Map<String, dynamic>) throw Exception("Data simulasi tidak valid.");

    return LoanSimulationResultModel.fromJson(data);
  }

  static Future<dynamic> submitLoanApplication({required String bprId, required LoanApplicationFormModel form}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final formData = FormData.fromMap({
      "bpr_id": bprId,
      "user_login": "SYSTEM",
      "term": "web",
      "no_id": form.noId,
      "nama": form.nama,
      "no_hp": form.noHp,
      "alamat": form.alamat,
      "jaminan": form.jaminan,
      "nilai_pinjaman": form.nilaiPinjaman,
      "jk_waktu": form.jkWaktu,
      "rate": form.rate,
      "cicilan": form.cicilan,
    });

    if (form.fotoJaminanBytes != null && form.fotoJaminanBytes!.isNotEmpty) {
      formData.files.add(
        MapEntry("fhoto_jaminan", MultipartFile.fromBytes(form.fotoJaminanBytes!, filename: form.fotoJaminanName ?? "foto_jaminan.jpg")),
      );
    }

    final response = await dio.post(NetworkURL.daftarPermohonanPinjaman(), data: formData);
    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("SUBMIT LOAN FIELDS: ${formData.fields}");
      print("SUBMIT LOAN FILES: ${formData.files.map((e) => e.value.filename).toList()}");
      print("SUBMIT LOAN RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response permohonan pinjaman tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal mendaftarkan permohonan pinjaman.");

    return res;
  }

  static Future<List<LoanNotificationRecipientModel>> inquiryNotificationRecipients({required String bprId}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquiryNotifikasiPinjaman(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB"});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response inquiry notifikasi tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal inquiry penerima notifikasi.");

    final data = res['data'];
    if (data is! List) return [];

    return data.map((e) => LoanNotificationRecipientModel.fromJson(Map<String, dynamic>.from(e))).where((e) => e.cif.trim().isNotEmpty).toList();
  }

  static Future<bool> sendPushNotification({required String title, required String body, required String bprId, required String noCif}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.pushNotifPinjaman(), data: {"title": title, "bpr_id": bprId, "body": body, "no_cif": noCif});

    final res = response.data is String ? jsonDecode(response.data) : response.data;
    return res is Map<String, dynamic> && res['value'] == 1;
  }

  static Future<LoanNotificationResultModel> notifyLoanStaff({required String bprId, required LoanApplicationFormModel form}) async {
    final recipients = await inquiryNotificationRecipients(bprId: bprId);
    if (recipients.isEmpty) throw Exception("Staff PIC pinjaman belum tersedia.");

    final title = "Pengajuan Pinjaman Baru";
    final body = "${form.nama} mengajukan pinjaman Rp ${form.nilaiPinjaman} dengan tenor ${form.jkWaktu} bulan.";

    int successCount = 0;
    int failedCount = 0;

    for (final recipient in recipients) {
      final success = await sendPushNotification(title: title, body: body, bprId: bprId, noCif: recipient.cif);

      success ? successCount++ : failedCount++;
    }

    return LoanNotificationResultModel(totalRecipient: recipients.length, successCount: successCount, failedCount: failedCount);
  }

  static Future<List<LoanApplicationStatusModel>> inquiryStatusPinjaman({required String nama, required String noHp}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(
      NetworkURL.inquiryPermohonanPinjaman(),
      data: {
        "filter": {
          "status": "",
          "nama": nama,
          "no_hp": noHp,
          "user_handle": "",
          "nilai_pinjaman": {"min": 0, "max": 0},
          "jk_waktu": 0,
          "created_at": {"from": "", "to": ""},
        },
        "pagination": {"page": 1, "limit": 100},
        "sort": {"by": "created_at", "order": "desc"},
      },
    );

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("INQUIRY STATUS PINJAMAN RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) {
      throw Exception("Response status pinjaman tidak valid.");
    }

    if (res['code'] != '000') {
      throw Exception(res['message'] ?? "Data permohonan pinjaman tidak ditemukan.");
    }

    final data = res['data'];
    if (data is! Map<String, dynamic>) return [];

    final rows = data['data'];
    if (rows is! List) return [];

    return rows.map((e) => LoanApplicationStatusModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
