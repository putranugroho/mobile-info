import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../network/network.dart';
import '../../models/loan_master_model.dart';
import '../../models/loan_tagihan_model.dart';

class LoanRepository {
  static Future<Map<String, dynamic>> getLoanData({required String userlogin, required String bprId, required String noRek}) async {
    final response = await http.post(
      Uri.parse(NetworkURL.inquiryPinjamanData()),
      headers: {'x-username': xusername, 'x-password': xpassword, 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": userlogin, "bpr_id": bprId, "no_rek": noRek, "token": token}),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['value'] == 1) {
      return json['data'];
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil data pinjaman');
    }
  }

  static LoanMasterModel parseMaster(Map<String, dynamic> data) {
    return LoanMasterModel.fromJson(data['master']);
  }

  static List<LoanTagihanModel> parseTagihan(Map<String, dynamic> data) {
    final List list = data['tagihan'] ?? [];
    return list.map((e) => LoanTagihanModel.fromJson(e)).toList();
  }
}
