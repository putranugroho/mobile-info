import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class HomeRepository {
  static Future<dynamic> homeData(String token, String url, int idUsers, String bprId) async {
    FormData formData = FormData.fromMap({"token": token, "id_users": idUsers, "bpr_id": bprId});
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

  static Future<dynamic> cekBalance(String token, String url, String noRek, String noHp, String bprId) async {
    FormData formData = FormData.fromMap({"token": token, "no_hp": noHp, "no_rek": noRek, "bpr_id": bprId});
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

  static Future<dynamic> productData(String url, String bprId) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(url, data: {"bpr_id": bprId, "term": "MOBILE", "user_login": "admin"});

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }

  static Future<dynamic> publicBanner(String url, String bprId) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST BODY : {'bpr_id': $bprId}");
    }

    final response = await dio.post(url, data: {"bpr_id": bprId});

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA BANNER : ${response.data}");
    }

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }

  static Future<dynamic> bprProfile(String url, String bprId) async {
    Dio dio = Dio();

    dio.options.headers['api-key'] = '123';

    final response = await dio.post(url, data: {"action": "detail", "bpr_id": bprId});

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }

  static Future<dynamic> splashBannerPublic(String url) async {
    Dio dio = Dio();

    final response = await dio.post(url);

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }
}
