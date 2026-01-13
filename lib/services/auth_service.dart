import 'dart:convert' show jsonEncode;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyLoggedIn = 'logged_in';
  static const String _keyToken = 'auth_token';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<bool> get isLoggedIns async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logouts() async {
    final token = await getToken();

    if (token != null) {
      try {
        await http.post(Uri.parse('https://infoservices.medtrans.id/webServices/logout.php'), headers: {'Authorization': 'Bearer $token'});
      } catch (_) {}
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kIsWeb) {
      try {
        // ignore: undefined_prefixed_name
        // pesan ke container Web (jika dibungkus WebView)
        // akan diabaikan kalau tidak ada parent
        // gunakan js interop sederhana
        // tapi aman untuk web biasa
        // js interop inline
      } catch (_) {}
    }
  }
}
