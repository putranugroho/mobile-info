import 'dart:async';
import 'package:flutter/foundation.dart';

/// Singleton timer yang dipantau dari level aplikasi (lihat `builder` di MaterialApp)
/// sehingga reset idle-nya bekerja di semua halaman, termasuk halaman yang
/// di-push sebagai route baru (di luar subtree MenuPage).
class InactivityService {
  InactivityService._();
  static final InactivityService instance = InactivityService._();

  static const Duration _duration = Duration(minutes: 5);

  Timer? _timer;
  VoidCallback? _onTimeout;

  void start(VoidCallback onTimeout) {
    _onTimeout = onTimeout;
    _reset();
  }

  void bump() {
    if (_timer == null || !_timer!.isActive) return;
    _reset();
  }

  void _reset() {
    _timer?.cancel();
    _timer = Timer(_duration, () => _onTimeout?.call());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _onTimeout = null;
  }
}
