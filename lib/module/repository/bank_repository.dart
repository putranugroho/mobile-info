import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../network/network.dart';

class BankRepository {
  static Future<dynamic> getBank(String token, String url) async {
    FormData formData = FormData.fromMap({
      "token": token,
    });
    Dio dio = Dio();

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

  static Future<dynamic> getBankAccount(
    String token,
    String url,
    int idUsers,
    int limit,
    int offset,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "id_users": idUsers,
      "offset": offset,
      "limit": limit,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> queryBank(
    String token,
    String url,
    int idUsers,
    String noRekening,
    String bank,
    String bankName,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "id_users": idUsers,
      "no_rekening": noRekening,
      "bank": bank,
      "bank_name": bankName,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }
}
