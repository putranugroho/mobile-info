import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/loan_master_model.dart';
import '../../models/loan_tagihan_model.dart';

class LoanRepository {
  static Future<Map<String, dynamic>> _fetchLoan(String noRek) async {
    final url = Uri.parse('http://103.96.147.187:4500/cms/inquiry/masterdata/tagihan-loan');

    final response = await http.post(
      url,
      headers: {'api-key': 'l1ZJ0xStZoruZq8NgrRKNA==', 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": "admin", "bpr_id": "600931", "no_rek": noRek}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['code'] == "000") {
      return data['data'];
    } else {
      throw Exception(data['message']);
    }
  }

  static Future<LoanMasterModel> getMaster(String noRek) async {
    final data = await _fetchLoan(noRek);
    return LoanMasterModel.fromJson(data['master']);
  }

  static Future<List<LoanTagihanModel>> getTagihan(String noRek) async {
    final data = await _fetchLoan(noRek);
    final List list = data['tagihan'] ?? [];
    return list.map((e) => LoanTagihanModel.fromJson(e)).toList();
  }
}
