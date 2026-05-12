import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../network/network.dart';
import '../../models/loan_master_model.dart';
import '../../models/loan_tagihan_model.dart';

class LoanRepository {
  static Future<Map<String, dynamic>> getLoanData({required String userlogin, required String bprId, required String noRek}) async {
    final response = await http.post(
      Uri.parse(NetworkURL.inquiryPinjamanData()),
      headers: {'api-key': '123', 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": userlogin, "bpr_id": bprId, "term": "WEB", "no_rek": noRek}),
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['code'] == '000') {
      return Map<String, dynamic>.from(json['data']);
    }

    throw Exception(json['message'] ?? 'Gagal mengambil data pinjaman');
  }

  static LoanMasterModel parseMaster(Map<String, dynamic> data) {
    return LoanMasterModel.fromJson(Map<String, dynamic>.from(data['master']));
  }

  static List<LoanTagihanModel> parseTagihan(Map<String, dynamic> data) {
    final List list = data['tagihan'] ?? [];
    return list.map((e) => LoanTagihanModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
