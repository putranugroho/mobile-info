import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mobile_info/models/deposito_digital_model.dart';
import 'package:mobile_info/network/network.dart';

/// Endpoint web-service-medfo hanya mengizinkan header Content-Type/API-Key (CORS),
/// jadi jangan tambahkan x-username/x-password -- di Flutter Web akan diblokir browser.
class DepositoDigitalRepository {
  static Dio _dio() {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  }

  static Map<String, dynamic> _decode(dynamic raw) {
    final v = raw is String ? jsonDecode(raw) : raw;
    return Map<String, dynamic>.from(v as Map);
  }

  /// Deposito digital milik nasabah, key = nomor rekening deposito.
  static Future<Map<String, DepositoDigitalInfo>> getDigitalNasabah({required String bprId, required String noCif}) async {
    final res = _decode((await _dio().post(NetworkURL.depositoDigitalNasabah(), data: {"bpr_id": bprId, "nocif": noCif})).data);
    if ('${res['code']}' != '000' || res['data'] is! List) return {};
    final map = <String, DepositoDigitalInfo>{};
    for (final e in res['data'] as List) {
      final info = DepositoDigitalInfo.fromJson(Map<String, dynamic>.from(e));
      if (info.noRek.isNotEmpty) map[info.noRek] = info;
    }
    return map;
  }

  /// PDF bilyet digital dari server (sudah memuat format BPR, e-meterai, dan QR).
  static Future<Uint8List> getBilyetPdf({required String bprId, required String noDeposito, required String noBilyet}) async {
    final response = await _dio().post(
      NetworkURL.bilyetDigital(),
      data: {"bpr_id": bprId, "no_deposito": noDeposito, "no_bilyet": noBilyet},
      options: Options(validateStatus: (_) => true),
    );
    final res = _decode(response.data);
    final data = res['data'];
    if ('${res['code']}' != '000' || data is! Map || '${data['file'] ?? ''}'.isEmpty) {
      throw Exception(res['message'] ?? 'Bilyet digital belum tersedia.');
    }
    return base64Decode('${data['file']}');
  }

  /// Permohonan penutupan deposito digital. Melempar Exception(message) bila ditolak.
  static Future<String> daftarPenutupan({
    required String bprId,
    required String noCif,
    required String nama,
    required String kdKantor,
    required String noDep,
    required String tglJtempo, // yyyyMMdd
    required String rekTab,
    required num pokok,
    required num bunga,
    required num penalty,
    required num pajak,
    required String userLogin,
  }) async {
    final body = {
      "bpr_id": bprId,
      "no_cif": noCif,
      "nama": nama,
      "kd_kantor": kdKantor,
      "no_dep": noDep,
      "tgljtempo": tglJtempo,
      "rek_tab": rekTab,
      "pokok": pokok,
      "bunga": bunga,
      "penalty": penalty,
      "pajak": pajak,
      "user_login": userLogin,
      "term": "mobile",
    };
    final response = await _dio().post(NetworkURL.penutupanDepositoDigital(), data: body, options: Options(validateStatus: (_) => true));
    final res = _decode(response.data);
    if ('${res['code']}' != '000') {
      throw Exception(res['message'] ?? 'Permohonan penutupan gagal.');
    }
    return '${res['message'] ?? 'Permohonan penutupan deposito berhasil diajukan.'}';
  }
}
