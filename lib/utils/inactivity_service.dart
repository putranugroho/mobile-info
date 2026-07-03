import 'dart:async';
import 'package:flutter/foundation.dart';

class InactivityService {
  InactivityService._();
  static final InactivityService instance = InactivityService._();

  static const Duration timeoutDuration = Duration(minutes: 5);
  static const Duration pingInterval = Duration(minutes: 2);

  Timer? _timer;
  VoidCallback? _onTimeout;
  Future<void> Function()? _onActivity;

  DateTime? _lastPingAt;
  bool _isPinging = false;
  bool _isStarted = false;

  void start({
    required VoidCallback onTimeout,
    Future<void> Function()? onActivity,
    bool pingOnStart = false,
  }) {
    _onTimeout = onTimeout;
    _onActivity = onActivity;
    _isStarted = true;

    // Jangan ping langsung saat baru login/menu baru dibuka.
    // Login endpoint sudah membuat session baru. Ping langsung berpotensi race
    // dengan transisi page / data Pref sehingga user bisa terpental ke login.
    _lastPingAt = pingOnStart ? null : DateTime.now();

    _resetTimer();

    if (pingOnStart) {
      _pingIfNeeded(force: true);
    }
  }

  void bump() {
    if (!_isStarted) return;
    _resetTimer();
    _pingIfNeeded();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeoutDuration, () {
      if (!_isStarted) return;
      _onTimeout?.call();
    });
  }

  Future<void> _pingIfNeeded({bool force = false}) async {
    final callback = _onActivity;
    if (callback == null || _isPinging || !_isStarted) return;

    final now = DateTime.now();
    if (!force && _lastPingAt != null && now.difference(_lastPingAt!) < pingInterval) {
      return;
    }

    _lastPingAt = now;
    _isPinging = true;

    try {
      await callback();
    } catch (e) {
      debugPrint('ERROR INACTIVITY SESSION PING: $e');
    } finally {
      _isPinging = false;
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _onTimeout = null;
    _onActivity = null;
    _lastPingAt = null;
    _isPinging = false;
    _isStarted = false;
  }
}
