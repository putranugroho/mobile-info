import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_info/network/network.dart';

class TransferRepository {
  static Future<dynamic> transfer(
    String token,
    String url,
    String userId,
    String no_hp,
    String bpr_id,
    String no_rek,
    String bank_tujuan,
    String rek_tujuan,
    String nama_tujuan,
    String amount,
    String trans_fee,
    String keterangan,
    String trx_code,
    String trx_type,
    String tgl_trans,
    String rrn,
    String invoice,
    String pin,
    String? tujuanTransaksi,
    String? keteranganLain,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "users_id": userId,
      "keterangan_lain": keteranganLain,
      "tujuan_transaksi": tujuanTransaksi,
      "no_hp": no_hp,
      "bpr_id": bpr_id,
      "no_rek": no_rek,
      "bank_tujuan": bank_tujuan,
      "rek_tujuan": rek_tujuan,
      "nama_tujuan": nama_tujuan,
      "amount": amount,
      "trans_fee": trans_fee,
      "keterangan": keterangan,
      "trx_code": trx_code,
      "trx_type": trx_type,
      "tgl_trans": tgl_trans,
      "rrn": rrn,
      "invoice": invoice,
      "pin": pin,
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

  static Future<dynamic> transferFlip(String token, String url, String account_number, String bank_code, String amount) async {
    FormData formData = FormData.fromMap({"token": token, "account_number": account_number, "bank_code": bank_code, "amount": amount});
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

  static Future<dynamic> transferIn(
    String token,
    String url,
    String invoice,
    String no_rek,
    String bpr_id,
    String no_hp,
    String title,
    String nama,
    String email,
    String phone,
    int amount,
    int fee,
    String senderBank,
    String type,
    String senderBankType,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "invoice": invoice,
      "no_hp": no_hp,
      "bpr_id": bpr_id,
      "no_rek": no_rek,
      "amount": amount,
      "title": title,
      "nama": nama,
      "email": email,
      "phone": phone,
      "fee": fee,
      "sender_bank": senderBank,
      "sender_bank_type": senderBankType,
      "type": type,
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

  static Future<dynamic> inqueryRek(String token, String url, String invoice, String no_rek, String bpr_id, String no_hp, String tglTrans) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "invoice": invoice,
      "no_hp": no_hp,
      "bpr_id": bpr_id,
      "no_rek": no_rek,
      "tgl_trans": tglTrans,
      "rrn": invoice,
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

  static Future<dynamic> getBankVa(String token, String url, String bprId) async {
    FormData formData = FormData.fromMap({"token": token, "bpr_id": bprId});
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
