import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/deposito_detail_model.dart';

class DepositoRepository {
  static const String _baseUrl = 'http://103.96.147.187:4500';
  static const Map<String, String> _headers = {'api-key': 'l1ZJ0xStZoruZq8NgrRKNA==', 'Content-Type': 'application/json'};

  /// ===============================
  /// FETCH DETAIL DEPOSITO
  /// ===============================
  static Future<DepositoDetailModel> getDetailDeposito({required String noRekening}) async {
    final url = Uri.parse('$_baseUrl/cms/inquiry/masterdata/deposito');

    final response = await http.post(url, headers: _headers, body: jsonEncode({"userlogin": "admin", "bpr_id": "600931", "no_rek": noRekening}));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['code'] == "000") {
      return DepositoDetailModel.fromJson(data['data']);
    } else {
      throw Exception(data['message']);
    }
  }
}
