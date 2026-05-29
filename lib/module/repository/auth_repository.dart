import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class AuthRepository {
  static dynamic _decodeResponse(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }

    return data;
  }

  static Future<dynamic> login(
    String token,
    String url,
    String username,
    String password,
    String fcmToken, {
    String deviceId = '',
    String deviceName = '',
    String bprId = '',
  }) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final body = {
      "username": username,
      "password": password,
      "fcmToken": fcmToken,
      "device_id": deviceId,
      "device_name": deviceName,
      "bpr_id": bprId,
    };

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST LOGIN BODY : $body");
    }

    final response = await dio.post(url, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }

    return _decodeResponse(response.data);
  }

  static Future<dynamic> post(String url, Map<String, dynamic> body) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST BODY : $body");
    }

    final response = await dio.post(url, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA : ${response.data}");
      print("RESPONSE DATA TYPE : ${response.data.runtimeType}");
    }

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }

  static Future<dynamic> gantiPassword(String token, String url, String username, String passwordlama, String passwordbaru) async {
    FormData formData = FormData.fromMap({"token": token, "username": username, "passwordlama": passwordlama, "passwordbaru": passwordbaru});
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

  static Future<dynamic> cekLupaPassword(String token, String url, String usersId, String norek, String nohp) async {
    FormData formData = FormData.fromMap({"token": token, "users_id": usersId, "no_rek": norek, "no_hp": nohp});
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

  static Future<dynamic> updateLupaPassword(String token, String url, String usersId, String norek, String nohp, String sandi) async {
    FormData formData = FormData.fromMap({"token": token, "users_id": usersId, "no_rek": norek, "no_hp": nohp, "sandi": sandi});
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

  static Future<dynamic> lockScreen(String token, String url, String username, String password) async {
    FormData formData = FormData.fromMap({"token": token, "username": username, "password": password});
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

  static Future<dynamic> gantiPhoto(String token, String url, int idUsers, File? _file) async {
    String? fileName = _file!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "token": token,
      "id_users": idUsers,
      "image": await MultipartFile.fromFile(_file.path, filename: fileName),
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

  static Future<dynamic> validasiKtp(String token, String url, String ktp, String bprId, String noHp) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final body = {"token": token, "no_id": ktp, "bpr_id": bprId, "no_hp": noHp};

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST VALIDASI KTP BODY : $body");
    }

    final response = await dio.post(url, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA VALIDASI KTP : ${response.data}");
    }

    return _decodeResponse(response.data);
  }

  static Future<dynamic> verifyOtp(String token, String url, String phoneNumber, String otp) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final body = {"token": token, "phone_number": phoneNumber, "otp": otp};

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST VERIFY OTP BODY : $body");
    }

    final response = await dio.post(url, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA VERIFY OTP : ${response.data}");
    }

    return _decodeResponse(response.data);
  }

  static Future<dynamic> gantimpinIbpr(String token, String url, String bprId, String noHp, String noRek, String mpinLama, String mpinBaru) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "bpr_id": bprId,
      "no_hp": noHp,
      "no_rek": noRek,
      "mpin_baru": mpinBaru,
      "mpin_lama": mpinLama,
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
    print(formData.fields);
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

  static Future<dynamic> lupaSandiMedfo(String token, String url, String noHp, String bprId) async {
    FormData formData = FormData.fromMap({"token": token, "no_hp": noHp, "bpr_id": bprId});
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) print("ENDPOINT URL : $url");
    final response = await dio.post(url, data: formData);
    if (response.data is String) return jsonDecode(response.data);
    return response.data;
  }

  static Future<dynamic> updateSandiMedfo(String token, String url, String noHp, String sandiBaru) async {
    FormData formData = FormData.fromMap({"token": token, "no_hp": noHp, "sandi_baru": sandiBaru});
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) print("ENDPOINT URL : $url");
    final response = await dio.post(url, data: formData);
    if (response.data is String) return jsonDecode(response.data);
    return response.data;
  }

  static Future<dynamic> updateProfileMedfo(String token, String url, int idUsers, String nama, String noHp, String tglLahir) async {
    FormData formData = FormData.fromMap({"token": token, "id_users": idUsers, "nama": nama, "no_hp": noHp, "tgl_lahir": tglLahir});
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) print("ENDPOINT URL : $url");
    final response = await dio.post(url, data: formData);
    if (response.data is String) return jsonDecode(response.data);
    return response.data;
  }

  static Future<dynamic> logoutMedfo(String token, String url, int idUsers) async {
    FormData formData = FormData.fromMap({"token": token, "id_users": idUsers});
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) print("ENDPOINT URL : $url");
    final response = await dio.post(url, data: formData);
    if (response.data is String) return jsonDecode(response.data);
    return response.data;
  }

  static Future<dynamic> aktivasiMobileInfo(String url, String phone, String userid, String password) async {
    FormData formData = FormData.fromMap({"phone": phone, "userid": userid, "password": password});
    print(formData.fields);
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST AKTIVASI MOBILE INFO BODY : $body");
    }

    final response = await dio.post(url, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA AKTIVASI MOBILE INFO : ${response.data}");
    }

    return _decodeResponse(response.data);
  }

  static Future<dynamic> logoutMobileInfo({
    required String endpoint,
    required dynamic userId,
    required String username,
    required String deviceId,
    required String sessionToken,
    required String bprId,
  }) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final body = {
      "user_id": int.tryParse('$userId') ?? 0,
      "username": username,
      "device_id": deviceId,
      "session_token": sessionToken,
      "bpr_id": bprId,
    };

    if (kDebugMode) {
      print("ENDPOINT URL : $endpoint");
      print("REQUEST LOGOUT BODY : $body");
    }

    final response = await dio.post(endpoint, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGOUT : ${response.data}");
    }

    return _decodeResponse(response.data);
  }

  static Future<dynamic> sessionPingMobileInfo({
    required String endpoint,
    required dynamic userId,
    required String username,
    required String deviceId,
    required String sessionToken,
    required String bprId,
  }) async {
    Dio dio = Dio();

    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';

    final body = {
      "user_id": int.tryParse('$userId') ?? 0,
      "username": username,
      "device_id": deviceId,
      "session_token": sessionToken,
      "bpr_id": bprId,
    };

    if (kDebugMode) {
      print("ENDPOINT URL : $endpoint");
      print("REQUEST SESSION PING BODY : $body");
    }

    final response = await dio.post(endpoint, data: body);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA SESSION PING : ${response.data}");
    }

    return _decodeResponse(response.data);
  }
}
