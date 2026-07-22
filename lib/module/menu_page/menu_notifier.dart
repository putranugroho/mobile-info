import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/network/network.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/inactivity_service.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;

  MenuNotifier({required this.context}) {
    InactivityService.instance.start(
      onTimeout: () => _logOut(callBackend: true),
      onActivity: _pingSessionIfNeeded,
      pingOnStart: false,
    );
  }

  int page = 0;
  bool _isLoggingOut = false;

  Future<void> _pingSessionIfNeeded() async {
    if (_isLoggingOut) return;

    final users = await Pref().getUsers();
    if (users.id == 0) return;

    if (users.sessionToken.trim().isEmpty || users.loginDeviceId.trim().isEmpty) {
      debugPrint('SESSION PING SKIP: session token/device id kosong.');
      return;
    }

    try {
      final value = await AuthRepository.sessionPingMobileInfo(
        endpoint: NetworkURL.sessionPing(),
        userId: users.id,
        username: users.username,
        deviceId: users.loginDeviceId,
        sessionToken: users.sessionToken,
        bprId: users.bprId,
      );

      final body = value is Map<String, dynamic> ? value : {};
      final code = '${body['code'] ?? ''}';
      final status = body['status'] == true || '${body['status'] ?? ''}'.toLowerCase() == 'success';

      if (!status || code != '000') {
        final message = '${body['message'] ?? ''}';
        debugPrint('SESSION PING INVALID: $body');

        // Setelah user sudah berada di menu, response invalid dari backend berarti
        // session memang sudah tidak sah. Logout lokal saja agar tidak mengirim
        // request logout dengan session yang sudah invalid.
        if (message.toLowerCase().contains('session') || code == '401' || code == '404') {
          await _logOut(callBackend: false);
        }
        return;
      }

      final data = body['data'];
      if (data is Map) {
        await Pref().mergeSessionProfileFromMap(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      debugPrint('ERROR SESSION PING MOBILE INFO: $e');
      // Network error sesaat tidak langsung logout.
      // Timer idle 5 menit tetap berjalan.
    }
  }

  Future<void> _logOut({bool callBackend = true}) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    InactivityService.instance.stop();

    final users = await Pref().getUsers();

    if (callBackend && users.id != 0) {
      try {
        await AuthRepository.logoutMobileInfo(
          endpoint: NetworkURL.logout(),
          userId: users.id,
          username: users.username,
          deviceId: users.loginDeviceId,
          sessionToken: users.sessionToken,
          bprId: users.bprId,
        );
      } catch (e) {
        debugPrint('ERROR LOGOUT MOBILE INFO: $e');
      }
    }

    await Pref().remove();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }

  @override
  void dispose() {
    InactivityService.instance.stop();
    super.dispose();
  }

  void gantiPage(int value) {
    page = value;
    notifyListeners();
  }

  DateTime? currentBackPressTime;

  Future<bool> back() {
    if (page == 0) {
      final now = DateTime.now();
      const snackBar = SnackBar(content: Text('Tekan Kembali sekali lagi untuk keluar akun'));

      if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future.value(false);
      }

      _logOut(callBackend: true);
      return Future.value(false);
    } else {
      page = 0;
      notifyListeners();
      return Future.value(false);
    }
  }
}
