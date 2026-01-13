import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/deposito_detail_model.dart';
import '../../network/network.dart';

class DepositoRepository {
  static Future<DepositoDetailModel> getDetailDeposito({required String noRek, required String userlogin, required String bprId}) async {
    final uri = Uri.parse(NetworkURL.inquiryDepositoData());

    final response = await http.post(
      uri,
      headers: {'x-username': xusername, 'x-password': xpassword, 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": userlogin, "bpr_id": bprId, "no_rek": noRek, "token": token}),
    );

    final raw = response.body;
    final Map<String, dynamic> json = raw is String ? jsonDecode(raw) : raw;

    if (response.statusCode == 200 && json['value'] == 1) {
      return DepositoDetailModel.fromJson(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil detail deposito');
    }
  }
}
