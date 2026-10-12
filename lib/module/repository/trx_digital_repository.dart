import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile_info/models/trx_digital_model.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';

class TrxDigitalException implements Exception {
  final String message;
  final String code;
  final String reason;
  TrxDigitalException(this.message, {this.code = '', this.reason = ''});

  /// Akun IBPR belum diaktifkan untuk rekening tersebut.
  bool get ibprNotActivated => reason == 'IBPR_NOT_ACTIVATED';

  @override
  String toString() => message;
}

class TrxDigitalRepository {
  static Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    final users = await Pref().getUsers();
    final dio = Dio();
    dio.options.headers['api-key'] = '123';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 40);

    try {
      final response = await dio.post(
        endpoint,
        data: {"user_id": users.id, "device_id": users.loginDeviceId, "session_token": users.sessionToken, ...body},
        options: Options(validateStatus: (_) => true),
      );
      final raw = response.data;
      final json = raw is String ? jsonDecode(raw) : Map<String, dynamic>.from(raw);
      return Map<String, dynamic>.from(json);
    } on DioException {
      throw TrxDigitalException('Koneksi bermasalah. Silakan coba lagi.');
    }
  }

  static TrxDigitalException _error(Map<String, dynamic> json) {
    final data = json['data'];
    return TrxDigitalException(
      (json['message'] ?? 'Terjadi kesalahan').toString(),
      code: (json['code'] ?? '').toString(),
      reason: data is Map ? (data['reason'] ?? '').toString() : '',
    );
  }

  static Future<List<TrxDigitalSetupModel>> getSetup() async {
    final json = await _post(NetworkURL.trxDigitalSetup(), {});
    if (json['code'] != '000') throw _error(json);
    final list = (json['data'] as List?) ?? [];
    return list.map((e) => TrxDigitalSetupModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<TrxDigitalModel> create({required String noRek, required String jenis, required double nominal, required String mpin}) async {
    final users = await Pref().getUsers();
    final json = await _post(NetworkURL.trxDigitalCreate(), {"bpr_id": users.bprId, "no_rek": noRek, "jenis": jenis, "nominal": nominal, "mpin": mpin});
    if (json['code'] != '000') throw _error(json);
    return TrxDigitalModel.fromJson(Map<String, dynamic>.from(json['data']));
  }

  static Future<List<TrxDigitalModel>> history({String? noRek}) async {
    final json = await _post(NetworkURL.trxDigitalHistory(), {if (noRek != null) "no_rek": noRek});
    if (json['code'] != '000') throw _error(json);
    final list = (json['data'] as List?) ?? [];
    return list.map((e) => TrxDigitalModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
