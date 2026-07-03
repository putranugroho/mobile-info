import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/menu_page/menu_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';

class SplashScreenNotifier extends ChangeNotifier {
  final BuildContext context;

  SplashScreenNotifier({required this.context}) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await Pref().getUsers();
    if (!context.mounted) return;

    if (user.id == 0) {
      _goToLogin();
      return;
    }

    final result = await _validateSession();
    if (!context.mounted) return;

    if (result == _SplashSessionResult.valid || result == _SplashSessionResult.skipBecauseNetworkError) {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_) => const MenuPage()), (route) => false);
    } else {
      await Pref().remove();
      if (!context.mounted) return;
      _goToLogin();
    }
  }

  Future<_SplashSessionResult> _validateSession() async {
    final user = await Pref().getUsers();

    if (user.id == 0) return _SplashSessionResult.invalid;
    if (user.sessionToken.trim().isEmpty || user.loginDeviceId.trim().isEmpty) {
      return _SplashSessionResult.invalid;
    }

    if (_isLocalSessionExpired(user.loginExpiredAt)) {
      return _SplashSessionResult.invalid;
    }

    try {
      final value = await AuthRepository.sessionPingMobileInfo(
        endpoint: NetworkURL.sessionPing(),
        userId: user.id,
        username: user.username,
        deviceId: user.loginDeviceId,
        sessionToken: user.sessionToken,
        bprId: user.bprId,
      );

      final body = value is Map<String, dynamic> ? value : {};
      final code = '${body['code'] ?? ''}';
      final status = body['status'] == true || '${body['status'] ?? ''}'.toLowerCase() == 'success';

      if (!status || code != '000') {
        debugPrint('SPLASH SESSION INVALID: $body');
        return _SplashSessionResult.invalid;
      }

      final data = body['data'];
      if (data is Map<String, dynamic>) {
        await Pref().updateLoginSession(loginExpiredAt: '${data['login_expired_at'] ?? user.loginExpiredAt}');
      }

      return _SplashSessionResult.valid;
    } catch (e) {
      debugPrint('ERROR SPLASH SESSION VALIDATION: $e');

      // Kalau hanya network error sementara dan local session belum expired,
      // jangan paksa logout. Session akan diping lagi dari MenuNotifier.
      return _SplashSessionResult.skipBecauseNetworkError;
    }
  }

  bool _isLocalSessionExpired(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return false;

    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return false;

    return parsed.isBefore(DateTime.now());
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }
}

enum _SplashSessionResult { valid, invalid, skipBecauseNetworkError }
