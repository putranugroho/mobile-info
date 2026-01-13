import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/mutasi_tabungan_model.dart';
import '../../network/network.dart';

class MutasiRepository {
  /// ================= CORE FETCH =================
  static Future<List<dynamic>> fetchMutasi({
    required String endpoint,
    required String token,
    required String userlogin,
    required String bprId,
    required String noRek,
    required String periode,
  }) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['Content-Type'] = 'application/json';

    final response = await dio.post(endpoint, data: {"token": token, "userlogin": userlogin, "bpr_id": bprId, "no_rek": noRek, "periode": periode});

    final raw = response.data;
    final Map<String, dynamic> json = raw is String ? jsonDecode(raw) : raw;

    if (response.statusCode == 200 && json['value'] == 1) {
      return json['data'] ?? [];
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil mutasi tabungan');
    }
  }

  /// ================= MUTASI TABUNGAN =================
  static Future<List<MutasiTabunganModel>> getMutasiTabungan({
    required String endpoint,
    required String token,
    required String userlogin,
    required String bprId,
    required String noRek,
    required String periode,
  }) async {
    final List list = await fetchMutasi(endpoint: endpoint, token: token, userlogin: userlogin, bprId: bprId, noRek: noRek, periode: periode);

    return list.map((e) => MutasiTabunganModel.fromJson(e)).toList();
  }
}
