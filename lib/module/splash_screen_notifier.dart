import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class SplashScreenNotifier extends ChangeNotifier {
  final BuildContext context;

  SplashScreenNotifier({required this.context}) {
    checkAuth();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    context.go('/login');
  }

  Future<void> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        logout();
        return;
      }

      final res = await http.get(
        Uri.parse('https://ibprservices.medtrans.id/webServices/me.php'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        context.go('/dashboard');
      } else {
        logout();
      }
    } catch (_) {
      logout();
    }
  }
}
