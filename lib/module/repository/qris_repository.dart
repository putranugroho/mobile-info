import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class QrisRepository {
  static Future<dynamic> createQris(
    String token,
    String url,
    int amount,
    int fee,
    String city,
    String postalCode,
    String merchantName,
    String merchantID,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "amount": amount,
      "fee": fee,
      "city": city,
      "postalCode": postalCode,
      "merchantName": merchantName,
      "merchantID": merchantID,
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

  static Future<dynamic> inqueryMpin(String token, String url, String noRek, String noHp, String bprId, String mPin) async {
    FormData formData = FormData.fromMap({"token": token, "no_rek": noRek, "no_hp": noHp, "bpr_id": bprId, "m_pin": mPin});
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

  static Future<dynamic> listBpr(String token, String url) async {
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

  static Future<dynamic> validasiKtp(String token, String url, String ktp, String bprId, String noHp, String noRek) async {
    FormData formData = FormData.fromMap({"token": token, "no_id": ktp, "bpr_id": bprId, "no_hp": noHp, "no_rek": noRek});
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

  static Future<dynamic> mPinGenerated(String token, String url, String mPin) async {
    FormData formData = FormData.fromMap({"token": token, "m_pin": mPin});
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

  static Future<dynamic> aktivasiAkun(
    String token,
    String url,
    String nama,
    String mPin,
    String noRek,
    String noHp,
    String noId,
    String bprId,
    String usersId,
    String sandi,
    String deviceId,
    String bprLogo,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "nama": nama,
      "m_pin": mPin,
      "no_id": noId,
      "no_hp": noHp,
      "no_rek": noRek,
      "bpr_id": bprId,
      "users_id": usersId,
      "sandi": sandi,
      "device_id": deviceId,
      "bpr_logo": bprLogo,
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
