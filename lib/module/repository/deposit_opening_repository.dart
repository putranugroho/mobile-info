import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

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

  static Future<List<Map<String, dynamic>>> inquirySetupPembukaanDep({required String bprId}) async {
    final body = {
      "bpr_id": bprId,
      "user_login": "SYSTEM",
      "term": "web",
      "filter": {
        "status_pembukaan": "",
        "product_by": "",
        "jurnal": "",
        "nosbb": "",
        "namasbb": "",
        "status": "",
        "id": null,
      },
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
    final body = {
      "bpr_id": bprId,
      "userlogin": userLogin.trim().isNotEmpty ? userLogin.trim() : "SYSTEM",
      "term": "WEB",
    };

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
}
