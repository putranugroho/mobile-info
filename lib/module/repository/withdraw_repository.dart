import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class WithdrawRepository {
  static Future<dynamic> generatedToken(
    String token,
    String url,
    String bprId,
    String userId,
    String noRek,
    String noHp,
    int amount,
    String tglTransmis,
    String pin,
    String invoice,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "bpr_id": bprId,
      "users_id": userId,
      "no_rek": noRek,
      "no_hp": noHp,
      "amount": amount,
      "tgl_transmis": tglTransmis,
      "pin": pin,
      "invoice": invoice,
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

  static Future<dynamic> denomisasi(String token, String url) async {
    FormData formData = FormData.fromMap({"token": token});
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
