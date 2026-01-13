import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

int parseValue(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class RekeningInquiryRepository {
  static Future<String> inquiryNocif({required String token, required String userlogin, required String bprId, required String noRek}) async {
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(
      NetworkURL.inquiryRekData(),
      data: {
        "token": token,
        // "userlogin": userlogin,
        "userlogin": "kevint",
        // "bpr_id": bprId,
        "bpr_id": "609999",
        "trx_code": "0200",
        "trx_type": "TRX",
        "tgl_trans": "240407155400",
        "tgl_transmis": "240407155400",
        "rrn": "12345",
        // "no_rek": noRek,
        "no_rek": "1000201201000570",
        "gl_jns": "2",
      },
    );

    final Map<String, dynamic> json = response.data is String ? jsonDecode(response.data) : Map<String, dynamic>.from(response.data);

    final int value = parseValue(json['value']);

    if (value == 1) {
      return json['data']['nocif'].toString();
    } else {
      throw Exception(json['message'] ?? 'Gagal inquiry rekening');
    }
  }
}
