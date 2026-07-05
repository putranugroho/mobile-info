import 'dart:convert';
import 'package:dio/dio.dart';

import '../../models/mutasi_tabungan_model.dart';
import '../../network/network.dart';

class MutasiRepository {
  static Future<List<dynamic>> fetchMutasi({
    required String endpoint,
    required String token,
    required String userlogin,
    required String bprId,
    required String noRek,
    required String periode,
  }) async {
    final dio = Dio();

    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final response = await dio.post(endpoint, data: {"userlogin": userlogin, "bpr_id": bprId, "term": "WEB", "no_rek": noRek, "periode": periode});

    final raw = response.data;
    final Map<String, dynamic> json = raw is String ? jsonDecode(raw) : Map<String, dynamic>.from(raw);

    if (response.statusCode == 200 && json['code'] == '000') {
      return json['data'] ?? [];
    }

    throw Exception(json['message'] ?? 'Gagal mengambil mutasi tabungan');
  }

  static Future<Map<String, String>> getTcodeMap() async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final response = await dio.post(NetworkURL.tcode(), data: {"action": "list"});
    final raw = response.data;
    final Map<String, dynamic> json = raw is String ? jsonDecode(raw) : Map<String, dynamic>.from(raw);

    if (response.statusCode == 200 && json['code'] == '000') {
      final data = json['data'];
      if (data is! List) return {};

      final result = <String, String>{};
      for (final item in data) {
        if (item is! Map) continue;

        final row = Map<String, dynamic>.from(item);
        final code = (row['tcode'] ?? '').toString().trim();
        final label = (row['keterangan'] ?? row['description'] ?? '').toString().trim();

        // Untuk display riwayat mutasi, semua tcode dipakai, termasuk is_active=false.
        if (code.isNotEmpty && label.isNotEmpty) {
          result[code] = label;
        }
      }

      return result;
    }

    throw Exception(json['message'] ?? 'Gagal mengambil daftar tcode');
  }

  static Future<List<MutasiTabunganModel>> getMutasiTabungan({
    required String endpoint,
    required String token,
    required String userlogin,
    required String bprId,
    required String noRek,
    required String periode,
  }) async {
    final list = await fetchMutasi(endpoint: endpoint, token: token, userlogin: userlogin, bprId: bprId, noRek: noRek, periode: periode);

    return list.map((e) => MutasiTabunganModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
