import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/chat_api.dart';
import 'package:mobile_info/module/repository/chat_ws_service.dart';
import 'package:mobile_info/pref/pref.dart';

enum SupportMode { bot, waiting, liveChat }

class ChatNotifier extends ChangeNotifier {
  final BuildContext context;
  ChatNotifier({required this.context}) {
    _init();
  }

  final ScrollController scrollController = ScrollController();

  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;

    final position = scrollController.position.maxScrollExtent;

    if (animate) {
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(position);
    }
  }

  int? currentUserId;
  void _connectWs() {
    _ws.connect(
      token: token!,
      onConnected: () {
        print("WS connected");

        // 🔥 JOIN ROOM DI SINI
        _ws.joinRoom(roomId!);
      },
      onMessage: (data) {
        if (data["type"] != "message") return;
        if (data["room_id"] != roomId) return;
        if (data["user_id"] == currentUserId) return;

        messages.add({
          "from": data["role"] == "admin" ? "admin" : "user",
          "message": data["message"],
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        notifyListeners();
      },
      onError: (err) {
        print("WS error: $err");
      },
    );
  }

  final ChatApi _api = ChatApi();
  final ChatWsService _ws = ChatWsService();
  UsersModel? users;
  int? roomId;

  bool isLoading = false;
  bool isOpened = false;

  SupportMode mode = SupportMode.bot;

  String? token;
  List<Map<String, dynamic>> messages = [];

  // ================= INIT =================
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    users = await Pref().getUsers();
    if (users == null) return;

    await openSupport(externalUserId: "MOBILE_INFO_${users!.nomorPonsel}");
  }

  // ================= OPEN SUPPORT =================
  Future<void> openSupport({required String externalUserId}) async {
    isLoading = true;
    notifyListeners();

    final res = await _api.openSupportRoom(externalUserId);

    await Pref().saveToken(res["token"]);
    roomId = res['room_id'];
    currentUserId = res["user"]["id"];
    isOpened = true;
    token = res["token"];
    print("TOKEN USER : $token");

    _addAdmin("Hi Apakabar, apa yang bisa kami bantu?");
    _connectWs();
    isLoading = false;
    notifyListeners();
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || roomId == null) return;

    _addUser(text);

    notifyListeners();
    if (mode == SupportMode.bot) {
      // await _api.sendFirstSupportMessage(roomId!, text);
      await _api.sendMessage(roomId!, text);
      _addAdmin(
        "Baik kami akan mencoba menghubungkan Anda dengan Customer Service Live Agent Kami",
      );
      mode = SupportMode.liveChat;
      // await _assignAgent();
      return;
    }

    if (mode == SupportMode.liveChat) {
      await _api.sendMessage(roomId!, text);
    }
  }

  Future<void> _assignAgent() async {
    await _api.assignSupportAgent(roomId!);

    mode = SupportMode.liveChat;

    _addSystem(
      "Customer Service telah bergabung. Silakan lanjutkan percakapan.",
    );

    notifyListeners();
  }

  void _addUser(String text) {
    messages.add({"from": "user", "message": text});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    notifyListeners();
  }

  void _addAdmin(String text) {
    messages.add({"from": "admin", "message": text});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    notifyListeners();
  }

  void _addSystem(String text) {
    messages.add({"from": "system", "message": text});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    notifyListeners();
  }
}
