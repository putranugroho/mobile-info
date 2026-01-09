import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/tabungan_model.dart';
import '../../models/deposito_model.dart';
import '../../models/kredit_model.dart';

class RekeningRepository {
  static Future<Map<String, dynamic>> _fetchMasterData() async {
    final url = Uri.parse('http://103.96.147.187:4500/cms/inquiry/masterdata');

    final response = await http.post(
      url,
      headers: {'api-key': 'l1ZJ0xStZoruZq8NgrRKNA==', 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": "admin", "bpr_id": "600931", "nocif": "10000043917"}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['code'] == "000") {
      return data['data'];
    } else {
      throw Exception(data['message']);
    }
  }

  /// TABUNGAN
  static Future<List<TabunganModel>> getTabungan() async {
    final data = await _fetchMasterData();
    final List list = data['tabungan'] ?? [];
    return list.map((e) => TabunganModel.fromJson(e)).toList();
  }

  /// DEPOSITO
  static Future<List<DepositoModel>> getDeposito() async {
    final data = await _fetchMasterData();
    final List list = data['deposito'] ?? [];
    return list.map((e) => DepositoModel.fromJson(e)).toList();
  }

  /// ✅ PINJAMAN
  static Future<List<KreditModel>> getKredit() async {
    final data = await _fetchMasterData();
    final List list = data['kredit'] ?? [];
    return list.map((e) => KreditModel.fromJson(e)).toList();
  }
}
