import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/chat_api.dart';
import 'package:mobile_info/module/repository/chat_ws_service.dart';
import 'package:mobile_info/pref/pref.dart';

class BantuanNotifier extends ChangeNotifier {
  final BuildContext context;

  BantuanNotifier({required this.context}) {
    _init();
  }

  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final ChatApi _api = ChatApi();
  final ChatWsService _ws = ChatWsService();

  UsersModel? users;
  String? sessionId;
  String? token;

  bool isLoading = true;
  bool isConnected = false;
  List<Map<String, dynamic>> messages = [];
  final Set<String> _seenIds = {};

  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    users = await Pref().getUsers();

    try {
      final externalUserId = "MEDFO_${users!.bprId}_${users!.nomorPonsel}";
      final res = await _api.openSession(
        externalUserId: externalUserId,
        customerName: users!.nama,
        customerPhone: users!.nomorPonsel,
        bprId: users!.bprId,
      );

      sessionId = res['sessionId'] as String;
      token = res['token'] as String;

      final prevMessages = res['messages'] as List<dynamic>? ?? [];
      for (final m in prevMessages) {
        final id = m['id'] as String? ?? '';
        if (id.isNotEmpty) _seenIds.add(id);
        messages.add({"id": id, "from": m['from'], "message": m['message']});
      }

      if (messages.isEmpty) {
        _addSystem("Halo ${users!.nama}! 👋 Silakan sampaikan kendala Anda, CS kami siap membantu.");
      }

      _connectWs();
    } catch (e) {
      _addSystem("Gagal terhubung ke layanan bantuan. Silakan coba lagi.");
    }

    isLoading = false;
    notifyListeners();
  }

  void _connectWs() {
    if (sessionId == null || token == null) return;

    _ws.connect(
      sessionId: sessionId!,
      token: token!,
      onConnected: () {
        isConnected = true;
        notifyListeners();
      },
      onMessage: (data) {
        final from = data['from'] as String? ?? 'agent';
        if (from == 'user') return;

        final id = data['id'] as String? ?? '';
        if (id.isNotEmpty && _seenIds.contains(id)) return;
        if (id.isNotEmpty) _seenIds.add(id);

        final msg = data['message'] as String? ?? '';
        if (msg.isEmpty) return;

        messages.add({"id": id, "from": from, "message": msg});
        _scrollToBottom();
        notifyListeners();
      },
      onError: (err) {
        isConnected = false;
        notifyListeners();
      },
    );
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || sessionId == null || token == null) return;

    messages.add({"from": "user", "message": text});
    _scrollToBottom();
    notifyListeners();

    try {
      await _api.sendMessage(
        sessionId: sessionId!,
        token: token!,
        message: text,
      );
    } catch (_) {
      _addSystem("Gagal mengirim pesan. Periksa koneksi Anda.");
    }
  }

  void _addSystem(String text) {
    messages.add({"from": "system", "message": text});
    _scrollToBottom();
    notifyListeners();
  }

  @override
  void dispose() {
    _ws.disconnect();
    scrollController.dispose();
    super.dispose();
  }
}
