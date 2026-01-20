import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWsService {
  WebSocketChannel? _channel;

  void connect({
    required String token,
    required void Function(Map<String, dynamic>) onMessage,
    required void Function() onConnected,
    required void Function(dynamic error) onError,
  }) {
    final uri = Uri.parse("wss://api-chat.medtrans.id/ws?token=$token");
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen((data) {
      final payload = jsonDecode(data);

      if (payload["type"] == "connected") {
        onConnected();
        return;
      }

      onMessage(payload);
    }, onError: onError);
  }

  /// 🔥 JOIN ROOM
  void joinRoom(int roomId) {
    _channel?.sink.add(jsonEncode({"type": "join_room", "room_id": roomId}));
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
