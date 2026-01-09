import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/mutasi_tabungan_model.dart';

class MutasiRepository {
  static Future<List<MutasiTabunganModel>> getMutasiTabungan({
    required String noRek,
    required String periode, // yyyyMM
  }) async {
    final url = Uri.parse('http://103.96.147.187:4500/cms/inquiry/masterdata/mutasi-tabungan');

    final response = await http.post(
      url,
      headers: {'api-key': 'l1ZJ0xStZoruZq8NgrRKNA==', 'Content-Type': 'application/json'},
      body: jsonEncode({"userlogin": "admin", "bpr_id": "600931", "no_rek": noRek, "periode": periode}),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['code'] == "000") {
      final List list = json['data'];
      return list.map((e) => MutasiTabunganModel.fromJson(e)).toList();
    } else {
      throw Exception(json['message']);
    }
  }
}
