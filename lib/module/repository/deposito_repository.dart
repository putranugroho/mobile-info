import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/deposito_detail_model.dart';
import '../../network/network.dart';

class DepositoRepository {
  static Future<DepositoDetailModel> getDetailDeposito({required String noRek, required String userlogin, required String bprId}) async {
    final response = await http.post(
      Uri.parse(NetworkURL.inquiryDepositoData()),
      headers: {'api-key': '123', 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": userlogin, "bpr_id": bprId, "term": "WEB", "no_rek": noRek}),
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['code'] == '000') {
      return DepositoDetailModel.fromJson(Map<String, dynamic>.from(json['data']));
    }

    throw Exception(json['message'] ?? 'Gagal mengambil detail deposito');
  }
}
