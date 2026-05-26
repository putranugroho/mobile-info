import 'package:dio/dio.dart';

class ChatApi {
  static const String baseUrl = "https://ticketing.medtrans.id";

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<Map<String, dynamic>> openSession({
    required String externalUserId,
    required String customerName,
    required String customerPhone,
    required String bprId,
  }) async {
    final res = await _dio.post('/api/chat/open', data: {
      "externalUserId": externalUserId,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "bprId": bprId,
    });

    final json = res.data as Map<String, dynamic>;
    if (json["success"] != true) {
      throw Exception("Gagal membuka sesi bantuan: ${json['message']}");
    }
    return json["data"] as Map<String, dynamic>;
  }

  Future<String?> sendMessage({
    required String sessionId,
    required String token,
    required String message,
  }) async {
    final res = await _dio.post('/api/chat/message', data: {
      "sessionId": sessionId,
      "token": token,
      "message": message,
    });
    final json = res.data as Map<String, dynamic>?;
    return json?["data"]?["id"] as String?;
  }
}
