import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/tabungan_model.dart';
import '../../models/deposito_model.dart';
import '../../models/kredit_model.dart';
import '../../network/network.dart';

class RekeningRepository {
  /// ================= CORE FETCH =================
  static Future<Map<String, dynamic>> fetchMasterData({
    required String token,
    required String endpoint,
    required String userlogin,
    required String bprId,
    required String nocif,
  }) async {
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(endpoint, data: {"token": token, "userlogin": userlogin, "bpr_id": bprId, "nocif": nocif});

    final raw = response.data;

    // 🔥 INI KUNCI NYA
    final Map<String, dynamic> json = raw is String ? jsonDecode(raw) : raw;

    if (response.statusCode == 200 && json['code'] == "000") {
      return json['data'];
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil master data');
    }
  }

  /// ================= TABUNGAN =================
  static Future<List<TabunganModel>> getTabungan({
    required String token,
    required String endpoint,
    required String userlogin,
    required String bprId,
    required String nocif,
  }) async {
    final data = await fetchMasterData(token: token, endpoint: endpoint, userlogin: userlogin, bprId: bprId, nocif: nocif);

    final List list = data['tabungan'] ?? [];
    return list.map((e) => TabunganModel.fromJson(e)).toList();
  }

  /// ================= DEPOSITO =================
  static Future<List<DepositoModel>> getDeposito({
    required String token,
    required String endpoint,
    required String userlogin,
    required String bprId,
    required String nocif,
  }) async {
    final data = await fetchMasterData(token: token, endpoint: endpoint, userlogin: userlogin, bprId: bprId, nocif: nocif);

    final List list = data['deposito'] ?? [];
    return list.map((e) => DepositoModel.fromJson(e)).toList();
  }

  /// ================= KREDIT =================
  static Future<List<KreditModel>> getKredit({
    required String token,
    required String endpoint,
    required String userlogin,
    required String bprId,
    required String nocif,
  }) async {
    final data = await fetchMasterData(token: token, endpoint: endpoint, userlogin: userlogin, bprId: bprId, nocif: nocif);

    final List list = data['kredit'] ?? [];
    return list.map((e) => KreditModel.fromJson(e)).toList();
  }
}
