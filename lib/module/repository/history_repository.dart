import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class HistoryRepository {
  static Future<dynamic> riwayat(String token, String url, String noHp, String bprId, int limit, int offset, String tglAwal, String tglAkhir) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "limit": limit,
      "offset": offset,
      "no_hp": noHp,
      "bpr_id": bprId,
      "tgl_awal": tglAwal,
      "tgl_akhir": tglAkhir,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("RESPONSE DATA LOGIN : ${response.data}");
      }
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }
}
