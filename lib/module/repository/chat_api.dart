import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_info/pref/pref.dart';

class ChatApi {
  static const String baseUrl = "https://api-chat.medtrans.id";

  /// ambil token & app key dari Pref
  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final pref = Pref();
    final token = await pref.getToken();
    const appKey = "c2c6fe298cd44c7aa5c47f43af86d4dm";

    final headers = {"Content-Type": "application/json", "X-APP-KEY": appKey};

    if (withAuth && token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  // ======================================================
  // OPEN SUPPORT ROOM
  // POST /support/open.php
  // ======================================================
  Future<Map<String, dynamic>> openSupportRoom(String externalUserId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/support/open.php"),
      headers: await _headers(withAuth: false),
      body: jsonEncode({"external_user_id": externalUserId}),
    );

    final json = jsonDecode(res.body);

    if (res.statusCode != 200 || json["success"] != true) {
      throw Exception("Gagal membuka room bantuan");
    }

    return json;
  }

  // ======================================================
  // FIRST MESSAGE (BOT)
  // POST /support/first-message.php
  // ======================================================
  Future<void> sendFirstSupportMessage(int roomId, String message) async {
    final res = await http.post(
      Uri.parse("$baseUrl/support/first-message.php"),
      headers: await _headers(),
      body: jsonEncode({"room_id": roomId, "message": message}),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal mengirim pesan pertama");
    }
  }

  // ======================================================
  // ASSIGN AGENT
  // POST /support/assign-agent.php
  // ======================================================
  Future<void> assignSupportAgent(int roomId) async {
    final res = await http.post(Uri.parse("$baseUrl/support/assign-agent.php"), headers: await _headers(), body: jsonEncode({"room_id": roomId}));

    if (res.statusCode != 200) {
      throw Exception("Gagal assign customer service");
    }
  }

  // ======================================================
  // LIVE CHAT MESSAGE
  // POST /messages/send.php
  // ======================================================
  Future<void> sendMessage(int roomId, String message) async {
    final res = await http.post(
      Uri.parse("$baseUrl/messages/send.php"),
      headers: await _headers(),
      body: jsonEncode({"room_id": roomId, "message": message}),
    );

    if (res.statusCode != 200) {
      throw Exception("Gagal mengirim pesan");
    }
  }
}
